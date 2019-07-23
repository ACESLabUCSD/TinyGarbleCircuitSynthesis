/*
 This file is part of TinyGarble.

 TinyGarble is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 TinyGarble is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with TinyGarble.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "scheduling.h"

#include <string>
#include <cstring>
#include "parse_netlist.h"
#include "common.h"
#include "log.h"

enum Mark {
  UnMarked = 0,
  TempMarked = 1,  // Temporary mark
  PerMarked = 2   // Permanently mark
};

int TopologicalSortVisit(const ReadCircuit &read_circuit, vector<Mark>* marks,
                         int64_t current_unmark_index,
                         vector<int64_t>* sorted_list, vector<int64_t>* loop) {

  int64_t init_input_size = read_circuit.get_init_input_size();
  int64_t init_input_dff_size = init_input_size + read_circuit.dff_size;

  if (current_unmark_index < 0) {  // CONSTANT or IV 2nd input (-1) are sorted.
    return SUCCESS;
  } else if (marks->at(current_unmark_index) == Mark::TempMarked) {
    LOG(ERROR) << "There is a loop in the circuit." << endl;
    loop->push_back(current_unmark_index);
    return FAILURE;
  } else if (marks->at(current_unmark_index) == Mark::UnMarked) {
    marks->at(current_unmark_index) = Mark::TempMarked;
	
	int64_t unmarked_gate_index = read_circuit.wire_mapping[current_unmark_index - init_input_dff_size];

    if (TopologicalSortVisit(
        read_circuit,
        marks,
        read_circuit.gate_list[unmarked_gate_index].input[0],
        sorted_list, loop) == FAILURE) {
      loop->push_back(current_unmark_index);
      return FAILURE;
    }
    if (TopologicalSortVisit(
        read_circuit,
        marks,
        read_circuit.gate_list[unmarked_gate_index].input[1],
        sorted_list, loop) == FAILURE) {
      loop->push_back(current_unmark_index);
      return FAILURE;
    }

    marks->at(current_unmark_index) = Mark::PerMarked;
    sorted_list->push_back(current_unmark_index);
  }

  return SUCCESS;
}

int TopologicalSort(const ReadCircuit &read_circuit,
                    vector<int64_t>* sorted_list,
                    const ReadCircuitString& read_circuit_string) {

  int64_t init_input_size = read_circuit.get_init_input_size();
  int64_t init_input_dff_size = init_input_size + read_circuit.dff_size;

  sorted_list->clear();
  vector<Mark> marks(init_input_dff_size + read_circuit.gate_size,
                     Mark::UnMarked);

  // inputs are already sorted
  for (int64_t i = 0; i < init_input_dff_size; i++) {
    marks[i] = Mark::PerMarked;
    sorted_list->push_back(i);
  }

  while (true) {
    int64_t unmark_index = -1;
    // Everything is sorted.
    if (sorted_list->size() == init_input_dff_size + read_circuit.gate_size) {
      break;
    }
    for (int64_t i = 0; i < (int64_t) read_circuit.gate_size; i++) {
      //TODO: use a list to store unmarked.
      if (marks[init_input_dff_size + i] == Mark::UnMarked) {
        unmark_index = init_input_dff_size + i;
        break;
      }
    }
    if (unmark_index != -1) {  // There is an unmarked gate.
      vector<int64_t> loop;  // for detecting loop
      if (TopologicalSortVisit(read_circuit, &marks, unmark_index, sorted_list,
                               &loop) == FAILURE) {
        string loop_id_str = "";
        string loop_name_str = "";
        for (int64_t i = (int64_t) loop.size() - 1; i > 0; i--) {
          loop_name_str += read_circuit_string.gate_list_string[loop[i]
              - init_input_dff_size].output + "->";
          loop_id_str += std::to_string(loop[i] - init_input_dff_size) + "->";
        }
        loop_name_str += read_circuit_string.gate_list_string[loop[0]
            - init_input_dff_size].output;
        loop_id_str += std::to_string(loop[0] - init_input_dff_size);
        LOG(ERROR) << "Loop name: " << loop_name_str << endl << "Loop ID: "
                   << loop_id_str << endl;
        return FAILURE;
      }
    } else {
      break;  // there is no unmarked gate.
    }
  }

  CHECK_EXPR_MSG(
      sorted_list->size() == init_input_dff_size + read_circuit.gate_size,
      "Some gates are not sorted.");

  return SUCCESS;
}

int SortNetlist(ReadCircuit *read_circuit,
                const ReadCircuitString& read_circuit_string) {

  int64_t init_input_size = read_circuit->get_init_input_size();
  int64_t init_input_dff_size = init_input_size + read_circuit->dff_size;

  vector<int64_t> sorted_list;
  if (TopologicalSort(*read_circuit, &sorted_list, read_circuit_string) == FAILURE)
    return FAILURE;

  read_circuit->task_schedule.clear();
  read_circuit->task_schedule.resize(read_circuit->gate_list.size(), 0);
  for (int64_t i = init_input_dff_size; i < (int64_t) sorted_list.size(); i++) {
    read_circuit->task_schedule[i - init_input_dff_size] = sorted_list[i]
        - init_input_dff_size;  // align index
  }

  return SUCCESS;
}

int WriteMapping(const ReadCircuitString& read_circuit_string,
                 const ReadCircuit &read_circuit,
                 const string& out_mapping_filename) {

  std::ofstream f(out_mapping_filename, std::ios::out);
  if (!f.is_open()) {
    LOG(ERROR) << "can't open " << out_mapping_filename << endl;
    return FAILURE;
  }

  for (int64_t i = 0; i < (int64_t) read_circuit.dff_size; i++) {
    f << read_circuit_string.dff_list_string[i].output << " "
        << read_circuit.dff_list[i].output << endl;
  }

  for (int64_t i = 0; i < (int64_t) read_circuit.gate_size; i++) {
    int64_t gid = read_circuit.task_schedule[i];
    f << read_circuit_string.gate_list_string[gid].output << " "
        << read_circuit.gate_list[gid].output << endl;
  }

  f << "terminate " << read_circuit.terminate_id << endl;

  f.close();

  return SUCCESS;
}
