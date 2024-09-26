#include <iostream>
#include <string>
#include <vector>
#include "province.h"
#include <fstream>
#include <unordered_map>
#include <cmath>

using namespace std;


/*
* This program uses File I/O with 2 config files.
* The format for each config file is very similar, below is an example for each:
*
* ProvinceConfig.txt
* --------------------
* ProvinceName1(STRING) ProvinceValue1(INT)
* ProvinceName2 ProvinceValue2
* ProvinceName3 ProvinceValue3
*
*
* MoneyToResourceConfig.txt
* -------------------------
* Cost1(INT) CrateNum1(INT)
* Cost2 CrateNum2
* Cost3 CrateNum3
*
* Reminder: DO NOT USE SPACES if province name has a space. Use Underscores instead. Example:
* San_Jose, Los_Angeles, etc...
*/



vector<vector<Province>> powerSet(vector<Province> country) {

	//Initializes the start of the power set
	vector<vector<Province>> powList;
	unsigned int size = (int)pow(2, country.size());
	vector<Province> emptySet;
	powList.reserve(size);
	powList.push_back(emptySet);

	//Actually populates the power set... See references for more info
	for (auto it = country.begin(); it != country.end(); it++) {
		unsigned int powSetSize = powList.size();
		for (size_t x = 0; x < powSetSize; x++) {
			vector<Province> tempVec;
			tempVec = powList.at(x);
			tempVec.push_back(*it);
			powList.push_back(tempVec);
		}
	}

	powList.erase(powList.begin());

	return powList;

}

void printPayoffs(vector<vector<Province>> powerSet, unordered_map<int,int> conversionRates) {
	
	//Traverses through the entire power sum vector
	for (int x = 0; x < powerSet.size(); x++) {
		
		//Used to compare final Payoff for Set
		int valSum = 0;
		//Used to print out the names of each Province
		vector<string> nameList;

		for (int y = 0; y < powerSet.at(x).size(); y++) {
			valSum += powerSet.at(x).at(y).getMoney();
			nameList.push_back(powerSet.at(x).at(y).getName());
		}

		//Compares to see which supply they can afford
		int tempClosest = 0;
		int bestFitCrate = 0;
		for (auto it = conversionRates.begin(); it != conversionRates.end(); it++) {
			if (it->first > valSum) {
				continue;
			}
			else if (it->first == valSum) {
				tempClosest = it->first;
				bestFitCrate = it->second;
				break;
			}
			else if (it->first < valSum) {
				if (tempClosest > it->first) {
					continue;
				}
				else {
					tempClosest = it->first;
					bestFitCrate = it->second;
				}
			}
		}

		cout << "(";
		//Actually prints out in a good format
		for (int j = 0; j < nameList.size(); j++) {
			if (nameList.size() == 1) {
				cout << nameList.at(j);
			}
			else {
				if (j != nameList.size() - 1) {
					cout << nameList.at(j) << ", ";
				}
				else {
					cout << nameList.at(j);
				}
			}
		}
		cout << ") can buy: " << bestFitCrate << " crates with a total of $" << valSum << endl;
	}
}


int main() {
	//Reads files
	ifstream read;
	ifstream read2;

	//Contains all province names and values
	vector<Province> country;

	//Hashmap where the conversion rates are set up
	unordered_map<int, int> conversionRates;
	
	string line;
	//Sets up a Hash Map to store the conversion rates
	read.open("MoneyToResourceConfig.txt");
	if (read.is_open()) {
		while (!read.eof()) {
			getline(read, line);
			int spacePos = line.find(" ");
			conversionRates.emplace(stoi(line.substr(0, spacePos)), stoi(line.substr(spacePos + 1)));
		}
	}

	string line2;
	//Sets up Country Vector
	read2.open("ProvinceConfig.txt");
	if (read2.is_open()) {
		int x = 0;
		while (!read2.eof()) {
			
			getline(read2, line2);
			int spacePos = line2.find(" ");
			string name = line2.substr(0, spacePos);
			int money = stoi(line2.substr(spacePos + 1));
			Province prov(name, money);
			country.push_back(prov);
			
		}

	}

	//This function takes in all of the provinces in country vector to create a power set without the empty set.
	vector<vector<Province>> powSet = powerSet(country);

	//Uses the power set and conversion Rates table to print out the payoffs for each set of provinces.
	printPayoffs(powSet, conversionRates);


}



/*
REFERENCES:

Power Sets- https://stackoverflow.com/questions/49469238/get-all-combinations-without-duplicates

*/