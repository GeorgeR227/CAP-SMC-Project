#pragma once
#include <string>

using namespace std;

class Province {
	string provName;
	int provMoney;

public:
	Province(string name, int money) {
		this->provMoney = money;
		this->provName = name;
	}

	string getName() {
		return this->provName;
	}

	int getMoney() {
		return this->provMoney;
	}

};