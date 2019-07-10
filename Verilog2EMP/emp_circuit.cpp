/*
 This file is part of JustGarble.

 JustGarble is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 JustGarble is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with JustGarble.  If not, see <http://www.gnu.org/licenses/>.

 */
/*
 This file is part of TinyGarble. It is modified version of JustGarble
 under GNU license.

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

#include "emp_circuit.h"

#include <cerrno>
#include <cstring>
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <new>
#include "log.h"

int WriteCircuit(const ReadCircuit& read_circuit, const string &file_name) {
	std::ofstream f(file_name.c_str(), std::ios::out);
	if (!f.is_open()) {
		LOG(ERROR) << "can't open " << file_name << endl;
		return -1;
	}
	
	int num_gate, num_wire, n1, n1_0, n2, n2_0, n3;
  
	num_gate = read_circuit.dff_size + read_circuit.gate_size;
	n1 = read_circuit.e_init_size + read_circuit.e_input_size;
	n1_0 = read_circuit.e_init_size;
	n2 = read_circuit.g_init_size + read_circuit.g_input_size;
	n2_0 = read_circuit.g_init_size;
	num_wire = num_gate + n1 + n2;
	n3 = read_circuit.output_size;
	
	f << num_gate << " " << num_wire << endl;
	f << n1 << " " << n1_0 << " " << n2 << " " << n2_0 << " " <<  n3 << endl << endl;
	
	for (uint64_t i = 0; i < read_circuit.dff_size; i++) {
		f << "2 1 ";
		f << read_circuit.dff_list[i].input[0] << " " << read_circuit.dff_list[i].input[1] << " " << read_circuit.dff_list[i].output;	//0->D; 1->I
		f << " DFF" << endl;
	}
  
    for (uint64_t j = 0; j < read_circuit.gate_size; j++) {
		uint64_t i =  read_circuit.wire_mapping[read_circuit.task_schedule[j]];
		if(read_circuit.gate_list[i].type == NOTGATE) {
			f << "1 1 ";
			f << read_circuit.gate_list[i].input[0] << " " << read_circuit.gate_list[i].output;
		}
		else {
			f << "2 1 ";
			f << read_circuit.gate_list[i].input[0] << " " << read_circuit.gate_list[i].input[1] << " " << read_circuit.gate_list[i].output;
		}
		if(read_circuit.gate_list[i].type == NOTGATE) f << " INV";
		else if (read_circuit.gate_list[i].type == ANDGATE) f << " AND";
		else if (read_circuit.gate_list[i].type == XORGATE) f << " XOR";
		else{ 
			LOG(ERROR) << "unsupported gate." << endl;
			return FAILURE;
		}
		f << endl;
	}
  
  f.close();

  return 0;
}
