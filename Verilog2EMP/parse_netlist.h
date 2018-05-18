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

#ifndef PARSE_NETLIST_H_
#define PARSE_NETLIST_H_

#include "v_2_EMPCircuit.h"
#include <map>

string Type2StrGate(short itype);
int ParseNetlist(const string &file_name,
                 ReadCircuitString* read_circuit_string);
bool isOutPort(string output);
void AddWireArray(std::map<string, int64_t>& wire_name_table, const string& name,
                  uint64_t size, int64_t *wire_index);
int IdAssignment(const ReadCircuitString& read_circuit_string,
                 ReadCircuit* read_circuit);
int TopologicalSort(const ReadCircuit &read_circuit,
                    vector<int64_t>* sorted_list,
                    const ReadCircuitString& read_circuit_string);

#endif /* PARSE_NETLIST_H_ */
