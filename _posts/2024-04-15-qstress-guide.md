---
title: Qstress Guide

date: 2024-04-15 15:00:00 -0700

categories: [Programming, Guide]

tags: []
---

[qstress](https://github.com/lwm7708/qstress) is a simple tool for stress testing in competitive
programming.

## Installation

Install qstress using a Python package manager ([pipx](https://pipx.pypa.io/stable/) is recommended
for Python executables).

```console
$ pipx install qstress
```

or

```console
$ pip install qstress
```

## Usage

### Compare

Generates test cases and compares outputs from two programs.
Compares the outputs of `main_file` and `slow_file` using tests generated by `gen_file`.

#### Example

We will use `main.cpp`{: .filepath}, `slow.cpp`{: .filepath}, and `gen.cpp`{: .filepath}.
The task is just outputting `a + b`.

We will purposely provide an incorrect solution in `main.cpp`{: .filepath}.

```cpp
#include <ios>
#include <iostream>

auto solve() {

    auto a = 0;
    auto b = 0;

    std::cin >> a >> b;

    if (a == 0) {
        std::cout << 0 << '\n';
        return;
    }

    std::cout << a + b << '\n';

}

auto main() -> int {

    std::cin.tie(nullptr);

    std::ios_base::sync_with_stdio(false);

    solve();

    return 0;

}
```
{: file='main.cpp'}

We add a slower but correct solution in `slow.cpp`{: .filepath}.

> Keep whitespace consistent between the two programs.
{: .prompt-warning}

```cpp
#include <ios>
#include <iostream>

auto solve() {

    auto a = 0;
    auto b = 0;

    std::cin >> a >> b;

    while (b) {
        if (b < 0) {
            --a;
            ++b;
        } else {
            ++a;
            --b;
        }
    }

    std::cout << a << '\n';

}

auto main() -> int {

    std::cin.tie(nullptr);

    std::ios_base::sync_with_stdio(false);

    solve();

    return 0;

}
```
{: file='slow.cpp'}

We also provide a generator to generate random test cases.

> When writing a generator, make sure to check if the problem uses multitest!
{: .prompt-warning}

```cpp
#include <chrono>
#include <ios>
#include <iostream>
#include <random>

namespace Random {

    auto rng = std::mt19937(std::chrono::steady_clock::now().time_since_epoch().count());

}

template <typename T>
auto nextInt(T a, T b) {

    return std::uniform_int_distribution<T>(a, b - 1)(Random::rng);

}

auto generate() {

    const auto a = nextInt(-10, 11);
    const auto b = nextInt(-10, 11);

    std::cout << a << ' ' << b << '\n';

}

auto main() -> int {

    std::ios_base::sync_with_stdio(false);

    generate();

    return 0;

}
```
{: file='gen.cpp'}

We can check our generator by generating a test.

```console
$ qstress gen gen.cpp
```

To start stress testing, we use the `cmp` command.

```console
$ qstress cmp main.cpp slow.cpp gen.cpp
```

You should probably get output indicating that you found a failing test case.
If not, you probably got very unlucky and none of the generated tests caused an incorrect answer.
In that case, rerun the previous command and consider increasing `tests`.

The failing test cases are saved as `<folder>/input_<n>.txt`{: .filepath}, where `<folder>` is
`test_cases`{: .filepath} by default.

To view the failing test cases, you can either open the files or use the `view` command.

```console
$ qstress view
```

#### Arguments

| Option      | Required | Type      | Description                         |
| :---------: | :------: | :-------: | :---------------------------------: |
| `main_file` | Yes      | `string`  | File to stress test                 |
| `slow_file` | Yes      | `string`  | File to compare against             |
| `gen_file`  | Yes      | `string`  | File to generate tests              |
| `tests`     | No       | `integer` | Max number of tests to run          |
| `find`      | No       | `integer` | Max number of failing tests to find |
| `folder`    | No       | `string`  | Folder to save failing tests        |

### Check

Generates test cases and checks whether output is valid.
Checks the output of `main_file` with `check_file` using tests generated by `gen_file`.

#### Example

We will use `main.cpp`{: .filepath}, `check.cpp`{: .filepath}, and `gen.cpp`{: .filepath}.
The task is finding `n` integers between `a` and `b` that sum to `s`.
It is guaranteed that there is a valid construction.

We will purposely provide an incorrect solution in `main.cpp`{: .filepath}.

```cpp
#include <ios>
#include <iostream>

auto solve() {

    auto a = 0;
    auto b = 0;
    auto n = 0;
    auto s = 0;

    std::cin >> n >> a >> b >> s;

    for (auto i = 0; i < n - 1; ++i) {
        std::cout << a << ' ';
    }

    std::cout << s - a * (n - 1) << '\n';

}

auto main() -> int {

    std::cin.tie(nullptr);

    std::ios_base::sync_with_stdio(false);

    solve();

    return 0;

}
```
{: file='main.cpp'}

We add a checker in `check.cpp`{: .filepath}.
The checker accesses the generated input from `input.txt`{: .filepath} and reads the output from
standard input.
The checker then outputs `1` if the output is valid or `0` if the output is invalid.

> This is different from typical Unix conventions, where `0` indicates success.
{: .prompt-warning}

```cpp
#include <fstream>
#include <ios>
#include <iostream>

auto fin = std::ifstream("input.txt");

auto check() {

    auto a = 0;
    auto b = 0;
    auto n = 0;
    auto s = 0;

    fin >> n >> a >> b >> s;

    auto is_val = true;
    auto sum = 0;

    for (auto i = 0; i < n; ++i) {
        auto val = 0;
        std::cin >> val;
        is_val &= val >= a && val <= b;
        sum += val;
    }

    std::cout << (is_val && sum == s) << '\n';

}

auto main() -> int {

    std::cin.tie(nullptr);

    std::ios_base::sync_with_stdio(false);

    check();

    return 0;

}
```
{: file='check.cpp'}

We also provide a generator to generate random test cases.

```cpp
#include <chrono>
#include <ios>
#include <iostream>
#include <random>

namespace Random {

    auto rng = std::mt19937(std::chrono::steady_clock::now().time_since_epoch().count());

}

template <typename T>
auto nextInt(T a, T b) {

    return std::uniform_int_distribution<T>(a, b - 1)(Random::rng);

}

auto generate() {

    const auto n = nextInt(2, 7);
    const auto a = nextInt(1, 11);

    std::cout << n << ' ' << a << ' ';

    const auto b = nextInt(a, 11);

    std::cout << b << ' ';

    const auto s = nextInt(a * n, b * n + 1);

    std::cout << s << '\n';

}

auto main() -> int {

    std::ios_base::sync_with_stdio(false);

    generate();

    return 0;

}
```
{: file='gen.cpp'}

To start stress testing, we use the `check` command.

```console
$ qstress check main.cpp check.cpp gen.cpp
```

You should probably get output indicating that you found a failing test case.
If not, you probably got very unlucky and none of the generated tests caused an incorrect answer.
In that case, rerun the previous command and consider increasing `tests`.

The failing test cases are saved as `<folder>/input_<n>.txt`{: .filepath}, where `<folder>` is
`test_cases`{: .filepath} by default.

To view the failing test cases, you can either open the files or use the `view` command with the
`checker` flag.

```console
$ qstress view --checker
```

#### Arguments

| Option       | Required | Type      | Description                         |
| :----------: | :------: | :-------: | :---------------------------------: |
| `main_file`  | Yes      | `string`  | File to stress test                 |
| `check_file` | Yes      | `string`  | File to check outputs               |
| `gen_file`   | Yes      | `string`  | File to generate tests              |
| `tests`      | No       | `integer` | Max number of tests to run          |
| `find`       | No       | `integer` | Max number of failing tests to find |
| `folder`     | No       | `string`  | Folder to save failing tests        |


## Configuration

The configuration is defined in `~/.qstress/config.json`{: .filepath}.

### Default Configuration

```json
{

    "compilerBin": "g++",

    "compileArgs": ["-O2", "-std=c++17"],

    "tests": 200,

    "find": 1,

    "folder": "test_cases"

}
```
{: file='~/.qstress/config.json'}

### Configuration Values

| Option        | Type              | Description                         |
| :-----------: | :---------------: | :---------------------------------: |
| `compilerBin` | `string`          | Path to the compiler                |
| `compileArgs` | `array<string>`   | Flags for the compiler              |
| `tests`       | `integer`         | Max number of tests to run          |
| `find`        | `integer`         | Max number of failing tests to find |
| `folder`      | `string`          | Folder to save failing tests        |