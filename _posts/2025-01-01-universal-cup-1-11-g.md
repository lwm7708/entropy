---
title: Rectangle (Universal Cup Season 1 Stage 11)

date: 2025-01-01 21:00:00 -0800

categories: [Programming, Solution]
---

## Statement

You are given $n$ $(1 \leq n \leq 10^{5})$ rectangles with coordinates in the range $[1, 10^{9}]$.

Find the number of ways, modulo $998244353$, of choosing $3$ distinct lines,
each vertical or horizontal,
in the rectangle from $(1, 1)$ to $(10^{9}, 10^{9})$ such that each rectangle is touched by at least
$1$ line.

You are given $T$ $(1 \leq T \leq 10^{5})$ test cases.

[Source](https://qoj.ac/problem/6304)

## Solution

Apply coordinate compression on all the given coordinates.
This gives us several ranges with different sizes.

We can split the orientation of the lines into 4 cases:

- 3 vertical lines
- 1 vertical line and 2 horizontal lines
- 3 horizontal lines
- 1 horizontal line and 2 vertical lines

We can solve for the first 2 cases,
and the next 2 cases can be solved in the same way as they are symmetric.

**3 vertical lines**

We can ignore the y coordinates of the rectangles.

Let us fix the range of the middle line.
We can maintain restrictions on the possible locations for the left and right lines.

For each range, we denote the length of the range as $m$,
the length of the range of possible left lines as $l$,
and the length of the range of possible right lines as $r$.

There are four cases to consider:
- $lmr$ - restrictions on left and right
- $\binom{m}{2} \cdot r$ - restrictions on left only
- $\binom{m}{2} \cdot l$ - restrictions on right only
- $\binom{m}{3}$ - no restrictions

**1 vertical line and 2 horizontal lines**

We will fix the range of the vertical line.
We now need a structure that is capable of inserting a range, removing a range,
and querying how many pairs of points touch all ranges at least once.

Let $(a, b)$ denote a pair of points that touch all the ranges,
and $[l_{i}, r_{i}]$ be each of the ranges currently in the structure.

We note that $a \leq \min r$ and $b \geq \max l$ or else it is impossible to touch all the ranges.

Define $f(x)$ to be the minimum invalid value for $b$ if $a = x$.
For each range $[l_{i}, r_{i}]$ we insert,
notice that it imposes a restriction for all $x < l_{i}$ that $f(x) \leq r_{i} + 1$.

We can maintain the ranges with a segment tree.

In each node $k$ of the segment tree, we maintain the sum of all $f(x)$ in the range,
applying only restrictions from the range,
as $s_{k}$ and the minimum restriction in the range as $m_{k}$.

Whenever we insert or remove a range $[l_{i}, r_{i}]$,
we update the sum and restriction at the node corresponding to $l_{i} - 1$.

For each ancestor $k$ of the node corresponding to $l_{i} - 1$,
let its left child be $c$ and its right child be $d$.

We can update $s_{k}$ to be the sum of the restrictions on the subtree of $c$ while applying $m_{d}$
to it and $s_{d}$.
To find the sum of the restrictions on the subtree of $c$, we walk downwards on the subtree,
comparing the current restrictions to $m_{d}$.
$m_{k}$ can be set to $\min(m_{c}, m_{d})$.

The complexity of a single update is $\mathcal{O}(\log^{2} n)$,
as we walk downwards $\mathcal{O}(\log n)$ steps for each of the $\mathcal{O}(\log n)$ ancestors.

To query, we first find the minimum and maximum possible values of $a$,
denoted as $a_{l}$ and $a_{r}$. We already know $a_{r}$ to be $\min r$.
To find $a_{l}$, we use the restriction that $b \geq \max l$.
Because $f(x)$ is increasing as $x$ increases,
we can find $a_{l}$ through binary search or by walking down the segment tree.

The number of pairs $(a, b)$ for the current range can be calculated as
$\sum_{i=a_{l}}^{a_{r}} f(i) - \max(i, \max l)$.
We can first calculate the sum of $f(x)$ using the segment tree,
making sure to apply restrictions from the right subtrees onto the left subtrees.
We can then subtract the $\max(i, \max l)$ values in $\mathcal{O}(1)$.
The complexity of a query is $\mathcal{O}(\log^{2} n)$.

The final time complexity is $\mathcal{O}(n \log^{2} n)$.
Apparently solutions in $\mathcal{O}(n \log n)$ exist using other techniques.

## Implementation

```c++
#include <algorithm>
#include <array>
#include <cstdint>
#include <ios>
#include <iostream>
#include <set>
#include <utility>
#include <vector>

namespace segment_tree {

    constexpr std::int32_t log_2(std::int32_t);

    template <typename F>
    void for_pars(std::int32_t nd, std::int32_t dir, F f) {

        const std::int32_t lvls = log_2(nd);

        for (std::int32_t i = 1; i <= lvls; ++i) {
            f(nd >> (dir == 0 ? lvls - i + 1 : i));
        }

    }

    template <typename F>
    void for_rng(std::int32_t nd_l, std::int32_t nd_r, F f) {

        while (nd_l < nd_r) {
            if (nd_l & 1) {
                f(nd_l);
                ++nd_l;
            }
            if (nd_r & 1) {
                --nd_r;
                f(nd_r);
            }
            nd_l >>= 1;
            nd_r >>= 1;
        }

    }

    template <typename F>
    void for_rng_ord(std::int32_t nd_l, std::int32_t nd_r, F f) {

        if (nd_r - nd_l <= 0) {
            return;
        }

        const std::int32_t msk = (1 << log_2((nd_l - 1) ^ nd_r)) - 1;

        std::int32_t nd = -nd_l & msk;

        while (nd) {
            const std::int32_t bit = __builtin_ctz(nd);
            f(((nd_l - 1) >> bit) + 1);
            nd ^= 1 << bit;
        }

        nd = nd_r & msk;

        while (nd) {
            const std::int32_t bit = log_2(nd);
            f((nd_r >> bit) - 1);
            nd ^= 1 << bit;
        }

    }

    constexpr std::int32_t log_2(std::int32_t x) {

        return 31 - __builtin_clz(x);

    }

}

template <typename F>
class y_combinator {

private:

    F f;

public:

    explicit y_combinator(F&& f) : f(f) {}

    template <typename... Args>
    decltype(auto) operator()(Args&&... args) const {

        return f(*this, std::forward<Args>(args)...);

    }

};

template <typename F>
y_combinator(F) -> y_combinator<F>;

template <typename T>
std::array<T, 3> extended_gcd(T m, T n) {

    T a_m = 1;
    T a_n = 0;
    T b_m = 0;
    T b_n = 1;

    while (n) {
        const T q = m / n;
        a_n = std::exchange(a_m, a_n) - a_n * q;
        b_n = std::exchange(b_m, b_n) - b_n * q;
        n = std::exchange(m, n) - n * q;
    }

    return std::array<T, 3>({m, a_m, b_m});

}

template <std::int32_t MOD>
class modular_integer {

private:

    static constexpr std::int32_t MODULUS = MOD;

public:

    static std::int32_t get_modulus() {

        return MODULUS;

    }

    std::int32_t val;

    explicit modular_integer() : modular_integer(0) {}

    explicit modular_integer(std::int64_t val) : val(val % get_modulus()) {

        if (this->val < 0) {
            this->val += get_modulus();
        }

    }

    modular_integer operator-() const {

        return modular_integer(-val);

    }

    void operator++() {

        *this += modular_integer(1);

    }

    void operator--() {

        *this -= modular_integer(1);

    }

    void operator+=(modular_integer other) {

        if (other.val >= get_modulus() - val) {
            val -= get_modulus();
        }

        val += other.val;

    }

    void operator-=(modular_integer other) {

        val -= other.val;

        if (val < 0) {
            val += get_modulus();
        }

    }

    void operator*=(modular_integer other) {

        val = (std::int64_t(val) * other.val) % get_modulus();

    }

    void operator/=(modular_integer other) {

        *this *= modular_integer(extended_gcd(other.val, get_modulus())[1]);

    }

    friend modular_integer operator+(modular_integer lhs, modular_integer rhs) {

        lhs += rhs;

        return lhs;

    }

    friend modular_integer operator-(modular_integer lhs, modular_integer rhs) {

        lhs -= rhs;

        return lhs;

    }

    friend modular_integer operator*(modular_integer lhs, modular_integer rhs) {

        lhs *= rhs;

        return lhs;

    }

    friend modular_integer operator/(modular_integer lhs, modular_integer rhs) {

        lhs /= rhs;

        return lhs;

    }

};

void solve() {

    static constexpr std::int32_t MOD = 998244353;
    static constexpr std::int32_t MX = 1000000000;

    using num_t = modular_integer<MOD>;

    static const num_t inv_2 = num_t(1) / num_t(2);
    static const num_t inv_3 = num_t(1) / num_t(3);

    std::int32_t n;

    std::cin >> n;

    std::vector<std::int32_t> x_1(n);
    std::vector<std::int32_t> x_2(n);
    std::vector<std::int32_t> y_1(n);
    std::vector<std::int32_t> y_2(n);

    for (std::int32_t i = 0; i < n; ++i) {
        std::cin >> x_1[i] >> y_1[i] >> x_2[i] >> y_2[i];
        --x_1[i];
        --y_1[i];
        --x_2[i];
        --y_2[i];
    }

    const auto cmp = [&](
        std::vector<std::int32_t>& crds_1, std::vector<std::int32_t>& crds_2
    ) -> std::vector<std::int32_t> {
        std::vector cmp({std::int32_t(), MX});
        cmp.reserve(n * 3 + 2);
        cmp.insert(std::end(cmp), std::begin(crds_1), std::end(crds_1));
        cmp.insert(std::end(cmp), std::begin(crds_2), std::end(crds_2));
        for (auto x : crds_2) {
            cmp.push_back(x + 1);
        }
        std::sort(std::begin(cmp), std::end(cmp));
        cmp.erase(std::unique(std::begin(cmp), std::end(cmp)), std::end(cmp));
        for (auto& x : crds_1) {
            x = std::lower_bound(std::begin(cmp), std::end(cmp), x) - std::begin(cmp);
        }
        for (auto& x : crds_2) {
            x = std::lower_bound(std::begin(cmp), std::end(cmp), x) - std::begin(cmp);
        }
        return cmp;
    };
    num_t num_ways;

    std::vector cmp_x = cmp(x_1, x_2);
    std::vector cmp_y = cmp(y_1, y_2);

    std::int32_t sz_x = std::size(cmp_x);
    std::int32_t sz_y = std::size(cmp_y);

    for (std::int32_t i = 0; i < 2; ++i) {
        if (i) {
            std::swap(x_1, y_1);
            std::swap(x_2, y_2);
            std::swap(cmp_x, cmp_y);
            std::swap(sz_x, sz_y);
        }
        std::vector act(n, true);
        std::vector bnds(sz_y, std::multiset({MX}));
        std::multiset cur_ls({std::int32_t()});
        std::multiset cur_rs({sz_y - 2});
        std::vector<std::vector<std::int32_t>> evnts(sz_x);
        std::vector<bool> has_l(sz_x);
        std::vector<bool> has_r(sz_x);
        std::vector<std::int32_t> pfx_ls(sz_x);
        std::vector pfx_rs(sz_x, sz_x);
        const std::int32_t seg_sz = 1 << segment_tree::log_2(sz_y * 2 - 1);
        std::vector<std::int32_t> sfx_ls(sz_x);
        std::vector sfx_rs(sz_x, sz_x - 2);
        for (std::int32_t j = 0; j < n; ++j) {
            evnts[x_2[j]].push_back(j);
        }
        for (std::int32_t j = 1; j < sz_x; ++j) {
            pfx_ls[j] = pfx_ls[j - 1];
            pfx_rs[j] = pfx_rs[j - 1];
            has_l[j] = has_l[j - 1];
            for (auto x : evnts[j - 1]) {
                pfx_ls[j] = std::max(pfx_ls[j], x_1[x]);
                pfx_rs[j] = std::min(pfx_rs[j], x_2[x]);
                has_l[j] = true;
            }
        }
        for (auto& x : evnts) {
            x.clear();
        }
        for (std::int32_t j = 0; j < n; ++j) {
            evnts[x_1[j]].push_back(j);
        }
        for (std::int32_t j = sz_x - 2; j >= 0; --j) {
            sfx_ls[j] = sfx_ls[j + 1];
            sfx_rs[j] = sfx_rs[j + 1];
            has_r[j] = has_r[j + 1];
            for (auto x : evnts[j + 1]) {
                sfx_ls[j] = std::max(sfx_ls[j], x_1[x]);
                sfx_rs[j] = std::min(sfx_rs[j], x_2[x]);
                has_r[j] = true;
            }
        }
        for (std::int32_t j = 0; j < sz_x - 1; ++j) {
            pfx_rs[j] = std::min(pfx_rs[j], j - 1);
            sfx_ls[j] = std::max(sfx_ls[j], j + 1);
            const std::int32_t len_l = cmp_x[pfx_rs[j] + 1] - cmp_x[pfx_ls[j]];
            const std::int32_t len_m = cmp_x[j + 1] - cmp_x[j];
            const std::int32_t len_r = cmp_x[sfx_rs[j] + 1] - cmp_x[sfx_ls[j]];
            if (len_l > 0 && len_r > 0) {
                num_ways += num_t(len_l) * num_t(len_m) * num_t(len_r);
            }
            if (!has_l[j] && len_m >= 2 && len_r > 0) {
                num_ways += (num_t(len_m) * num_t(len_m - 1) * inv_2) * num_t(len_r);
            }
            if (!has_r[j] && len_m >= 2 && len_l > 0) {
                num_ways += (num_t(len_m) * num_t(len_m - 1) * inv_2) * num_t(len_l);
            }
            if (!has_l[j] && !has_r[j] && len_m >= 3) {
                num_ways += num_t(len_m) * num_t(len_m - 1) * num_t(len_m - 2) * inv_2 * inv_3;
            }
        }
        for (std::int32_t j = 0; j < n; ++j) {
            evnts[x_2[j] + 1].push_back(j);
        }
        std::vector seg_mns(seg_sz * 2, MX);
        std::vector<num_t> seg_sums(seg_sz * 2);
        std::vector<num_t> seg_szs(seg_sz * 2);
        for (std::int32_t j = 0; j < sz_y - 1; ++j) {
            seg_szs[seg_sz + j] = num_t(cmp_y[j + 1] - cmp_y[j]);
        }
        for (std::int32_t j = seg_sz - 1; j; --j) {
            seg_szs[j] = seg_szs[j << 1] + seg_szs[j << 1 | 1];
        }
        for (std::int32_t j = 1; j < seg_sz + sz_y; ++j) {
            seg_sums[j] = num_t(MX) * seg_szs[j];
        }
        const auto get_sum = y_combinator(
            [&](auto self, std::int32_t seg_node, std::int32_t val) -> num_t {
                if (seg_node >= seg_sz) {
                    return num_t(std::min(seg_mns[seg_node], val)) * seg_szs[seg_node];
                }
                const std::int32_t chd_l = seg_node << 1;
                const std::int32_t chd_r = seg_node << 1 | 1;
                if (seg_mns[chd_r] < val) {
                    return (seg_sums[seg_node] - seg_sums[chd_r]) + self(chd_r, val);
                } else {
                    return self(chd_l, val) + num_t(val) * seg_szs[chd_r];
                }
            }
        );
        const auto upd = [&](std::int32_t rng_l, std::int32_t rng_r, bool del) -> void {
            const auto erase = [](std::multiset<std::int32_t>& st, std::int32_t val) -> void {
                st.erase(st.find(val));
            };
            if (rng_l) {
                std::multiset<std::int32_t>& c_bnds = bnds[rng_l - 1];
                const std::int32_t node = seg_sz + (rng_l - 1);
                if (!del) {
                    c_bnds.insert(cmp_y[rng_r + 1]);
                } else {
                    erase(c_bnds, cmp_y[rng_r + 1]);
                }
                seg_mns[node] = *std::begin(c_bnds);
                seg_sums[node] = num_t(seg_mns[node]) * seg_szs[node];
                segment_tree::for_pars(
                    seg_sz + (rng_l - 1), 1,
                    [&](std::int32_t seg_node) -> void {
                        const std::int32_t chd_l = seg_node << 1;
                        const std::int32_t chd_r = seg_node << 1 | 1;
                        seg_sums[seg_node] = get_sum(chd_l, seg_mns[chd_r]) + seg_sums[chd_r];
                        seg_mns[seg_node] = std::min(seg_mns[chd_l], seg_mns[chd_r]);
                    }
                );
            }
            if (!del) {
                cur_ls.insert(rng_l);
                cur_rs.insert(rng_r);
            } else {
                erase(cur_ls, rng_l);
                erase(cur_rs, rng_r);
            }
        };
        for (std::int32_t j = 0; j < n; ++j) {
            upd(y_1[j], y_2[j], false);
        }
        for (std::int32_t j = 0; j < sz_x - 1; ++j) {
            for (auto x : evnts[j]) {
                upd(y_1[x], y_2[x], act[x]);
                act[x] = !act[x];
            }
            const std::int32_t bnd = cmp_y[*std::rbegin(cur_ls)];
            std::int32_t hi = sz_y;
            std::int32_t lo = -1;
            const std::int32_t qry_r = *std::begin(cur_rs) + 1;
            while (hi - lo > 1) {
                std::int32_t cur_bnd = MX;
                const std::int32_t mi = (lo + hi) / 2;
                y_combinator(
                    [&](
                        auto self, std::int32_t seg_node, std::int32_t tr_l, std::int32_t tr_r
                    ) -> void {
                        if (seg_node >= seg_sz) {
                            cur_bnd = std::min(cur_bnd, seg_mns[seg_node]);
                            return;
                        }
                        const std::int32_t tr_m = (tr_l + tr_r) / 2;
                        if (mi < tr_m) {
                            self(seg_node << 1, tr_l, tr_m);
                            cur_bnd = std::min(cur_bnd, seg_mns[seg_node << 1 | 1]);
                        } else {
                            self(seg_node << 1 | 1, tr_m, tr_r);
                        }
                    }
                )(1, 0, seg_sz);
                (cur_bnd > bnd ? hi : lo) = mi;
            }
            if (hi < qry_r) {
                num_t cur_ways;
                const std::int32_t crd_l = cmp_y[hi];
                const std::int32_t crd_r = cmp_y[qry_r] - 1;
                y_combinator(
                    [&](
                        auto self, std::int32_t seg_node, std::int32_t qry_l, std::int32_t qry_r,
                        std::int32_t tr_l, std::int32_t tr_r, std::int32_t val
                    ) -> void {
                        if (qry_l == tr_l && qry_r == tr_r) {
                            cur_ways += get_sum(seg_node, val);
                            return;
                        }
                        const std::int32_t chd_l = seg_node << 1;
                        const std::int32_t chd_r = seg_node << 1 | 1;
                        const std::int32_t tr_m = (tr_l + tr_r) / 2;
                        if (qry_l < tr_m) {
                            self(
                                chd_l, qry_l, std::min(qry_r, tr_m), tr_l, tr_m,
                                std::min(val, seg_mns[chd_r])
                            );
                        }
                        if (qry_r > tr_m) {
                            self(chd_r, std::max(qry_l, tr_m), qry_r, tr_m, tr_r, val);
                        }
                    }
                )(1, hi, qry_r, 0, seg_sz, MX + 1);
                if (crd_l < bnd) {
                    cur_ways -= num_t(bnd) * num_t(std::min(crd_r, bnd - 1) - crd_l + 1);
                }
                if (crd_r >= bnd) {
                    const std::int32_t crd = std::max(crd_l, bnd);
                    cur_ways -= num_t(crd + crd_r) * num_t(crd_r - crd + 1) * inv_2;
                    cur_ways -= num_t(crd_r - crd + 1);
                }
                num_ways += cur_ways * num_t(cmp_x[j + 1] - cmp_x[j]);
            }
        }
    }

    std::cout << num_ways.val << '\n';

}

int main() {

    std::cin.tie(nullptr);

    std::ios_base::sync_with_stdio(false);

    std::int32_t t;

    std::cin >> t;

    for (std::int32_t i = 0; i < t; ++i) {
        solve();
    }

    return 0;

}
```
