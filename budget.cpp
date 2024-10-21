#include <iostream>
#include <vector>
#include <sstream>

using namespace std;

// g++ -o budget budget.cpp

// Budget function based on 1/x
double budget_function(int x) {
    return 1.0 / (x + 1);
}

void calculate_and_print_budgets(int num_provinces, double total_resources = 100.0) {
    vector<double> raw_budgets(num_provinces);
    double total_raw_budget = 0.0;

    // Calculate raw budgets based on 1/x and sum them
    for (int i = 0; i < num_provinces; i++) {
        raw_budgets[i] = budget_function(i);
        total_raw_budget += raw_budgets[i];
    }

    cout << "Budgets by 1/x" << endl;

    // Make budgets sum to total resources
    for (int i = 0; i < num_provinces; i++) {
        double normalized_budget = (raw_budgets[i] / total_raw_budget) * total_resources;
        cout << "Province " << i + 1 << " budget: " << normalized_budget << endl;
    }
    cout << endl;
}

// Handling commas in input
string remove_commas(const string& str) {
    string result;
    for (size_t i = 0; i < str.length(); ++i) {
        if (str[i] != ',') {
            result += str[i];
        }
    }
    return result;
}

int main() {
    string num_provinces_str, total_resources_str;
    int num_provinces;
    double total_resources;

    cout << "Enter the total number of provinces: ";
    cin >> num_provinces_str;
    num_provinces_str = remove_commas(num_provinces_str);
    num_provinces = stoi(num_provinces_str); 

    cout << "Enter the total resources available: ";
    cin >> total_resources_str;
    total_resources_str = remove_commas(total_resources_str);
    total_resources = stod(total_resources_str);

    cout << endl;
    calculate_and_print_budgets(num_provinces, total_resources);

    return 0;
}
