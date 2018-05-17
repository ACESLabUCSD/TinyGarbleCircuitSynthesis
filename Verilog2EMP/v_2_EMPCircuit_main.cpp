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

#include "v_2_EMPCircuit.h"

#include <boost/program_options.hpp>
#include <boost/format.hpp>
#include <iostream>
#include <fstream>
#include "parse_netlist.h"
#include "circuit.h"
#include "scheduling.h"
#include "log.h"

namespace po = boost::program_options;
using std::ofstream;
using std::endl;

int main(int argc, char** argv) {
  LogInitial(argc, argv);

  string input_netlist_file;
  string output_circuit_file;

  boost::format fmter(
      "Verilog to EMPCircuit\nAllowed options");
  po::options_description desc(fmter.str());
  desc.add_options()  //
  ("help,h", "produce help message.")  //
  ("netlist,i", po::value<string>(&input_netlist_file),
   "Input netlist (verilog .v) file address.")  //
  ("emp,o", po::value<string>(&output_circuit_file),
   "Output EMPCircuit file address.");

  po::variables_map vm;
  try {
    po::parsed_options parsed = po::command_line_parser(argc, argv).options(
        desc).allow_unregistered().run();
    po::store(parsed, vm);
    if (vm.count("help")) {
      std::cout << desc << endl;
      return SUCCESS;
    }
    po::notify(vm);
  } catch (po::error& e) {
    LOG(ERROR) << "ERROR: " << e.what() << endl << endl;
    std::cout << desc << endl;
    return FAILURE;
  }

  if (output_circuit_file.empty()) {
    std::cerr << "ERROR: output circuit (-o) flag must be indicated." << endl;
    std::cout << desc << endl;
    return FAILURE;
  }

  string out_mapping_filename = output_circuit_file + ".map";

  if (!input_netlist_file.empty()) {
    LOG(INFO) << "V2EMPCircuit " << input_netlist_file << " to " << output_circuit_file
              << endl;
    if (Verilog2EMPCircuit(input_netlist_file, out_mapping_filename,
                    output_circuit_file) == FAILURE) {
      LOG(ERROR) << "Verilog to EMPCircuit failed." << endl;
      return FAILURE;
    }
  } else {
    std::cerr << "ERROR: input netlist flags must be indicated." << endl;
    std::cout << desc << endl;
    return FAILURE;
  }

  LogFinish();
  return SUCCESS;
}
