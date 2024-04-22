#include <iostream>
#include <omp.h>
#include <climits>
using namespace std;

void min_fn(int arr[], int n) {
    int min_value = INT_MAX;
    #pragma omp parallel for reduction(min:min_value)
    for(int i = 0; i < n; i++) {
        if(arr[i] < min_value) {
            min_value = arr[i];
        }
    }
    cout << "MIN value " << min_value << endl;
}

void max_fn(int arr[], int n) {
    int max_value = INT_MIN;
    #pragma omp parallel for reduction(max:max_value)
    for(int i = 0; i < n; i++) {
        if(arr[i] > max_value) {
            max_value = arr[i];
        }
    }
    cout << "MAX value " << max_value << endl;
}

void sum(int arr[], int n) {
    int sum = 0;
    #pragma omp parallel for reduction(+:sum)
    for(int i = 0; i < n; i++) {
        sum += arr[i];
    }
    cout << "Sum " << sum << endl;
}

void avg(int arr[], int n) {
    int sum = 0;
    #pragma omp parallel for reduction(+:sum)
    for(int i = 0; i < n; i++) {
        sum += arr[i];
    }
    cout << "AVG " << (sum / n) << endl;
}

int main() {
    int *a, n;
    cout << "Enter no of elements: ";
    cin >> n;
    a = new int[n];
    cout << "Enter the elements: ";
    for(int i = 0; i < n; i++) {
        cin >> a[i];
    }

    min_fn(a, n);
    max_fn(a, n);
    sum(a, n);
    avg(a, n);

    delete[] a; // free dynamically allocated memory
    return 0;
}
