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

#include "v_2_bmr.h"

#include "parse_netlist.h"
#include "bmr.h"
#include "scheduling.h"
#include "log.h"

using std::endl;

int Verilog2BMR(const string &in_file_name, const string& out_mapping_filename,
                const string &out_file_name, uint64_t no_of_parties, vector<uint64_t> bits_per_party) {

  ReadBMRCircuitString read_circuit_string;
  ReadBMRCircuit read_circuit;

  if (ParseNetlist(in_file_name, &read_circuit_string) == FAILURE) {
    LOG(ERROR) << "parsing verilog netlist failed." << endl;
    return FAILURE;
  }
  if (IdAssignment(read_circuit_string, &read_circuit, no_of_parties, bits_per_party) == FAILURE) {
    LOG(ERROR) << "id assignment to netlist components failed." << endl;
    return FAILURE;
  }
  if (SortNetlist(&read_circuit, read_circuit_string) == FAILURE) {
    LOG(ERROR) << "topological sort failed." << endl;
    return FAILURE;
  }

  if (WriteMapping(read_circuit_string, read_circuit,
                   out_mapping_filename) == FAILURE) {
    LOG(ERROR) << "Write mapping failed." << endl;
    return FAILURE;
  }

  if (WriteBMRcircuit(read_circuit, out_file_name) == FAILURE) {
    LOG(ERROR) << "write result to BMR file failed." << endl;
    return FAILURE;
  }

  return SUCCESS;
}

