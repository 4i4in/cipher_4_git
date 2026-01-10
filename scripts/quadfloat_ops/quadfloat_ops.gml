function get_quad_epsilon(dim)
{
    var n = log2(sqr(dim));
    var _exp = 16 + 2*n;
    return quadfloat_from_real( power(10, -_exp) );
}

function quadfloat_add(qf1, qf2)
{
    var sum_l2 = qf1.l2 + qf2.l2;
    var carry_l1 = sum_l2 * (1.0 / (1 << 53));
    var sum_l1 = qf1.l1 + qf2.l1 + carry_l1;
    var carry_h2 = sum_l1 * (1.0 / (1 << 53));
    var sum_h2 = qf1.h2 + qf2.h2 + carry_h2;
    var carry_h1 = sum_h2 * (1.0 / (1 << 53));
    var sum_h1 = qf1.h1 + qf2.h1 + carry_h1;

    sum_l2 -= carry_l1 * (1 << 53);
    sum_l1 -= carry_h2 * (1 << 53);
    sum_h2 -= carry_h1 * (1 << 53);

    return { h1: sum_h1, h2: sum_h2, l1: sum_l1, l2: sum_l2 };
}

function quadfloat_from_real(val)
{
    var h1 = val;
    var res1 = val - h1;
    var h2 = res1 * (1 << 53);
    var res2 = res1 - h2 / (1 << 53);
    var l1 = res2 * (1 << 53);
    var res3 = res2 - l1 / (1 << 53);
    var l2 = res3 * (1 << 53);
    return { h1: h1, h2: h2, l1: l1, l2: l2 };
}

function quadfloat_mul(qf1, qf2)
{
    // Dokładne mnożenie double-double (4 × double) – algorytm Dekker
    var p1 = qf1.h1 * qf2.h1;
    var p2 = qf1.h1 * qf2.h2;
    var p3 = qf1.h2 * qf2.h1;
    var p4 = qf1.h1 * qf2.l1;
    var p5 = qf1.l1 * qf2.h1;
    var p6 = qf1.h2 * qf2.h2;
    var p7 = qf1.h2 * qf2.l1;
    var p8 = qf1.l1 * qf2.h2;
    var p9 = qf1.l1 * qf2.l1;
    var p10 = qf1.h1 * qf2.l2;
    var p11 = qf1.l2 * qf2.h1;
    var p12 = qf1.l2 * qf2.l1;
    var p13 = qf1.l1 * qf2.l2;
    var p14 = qf1.l2 * qf2.h2;
    var p15 = qf1.h2 * qf2.l2;
    var p16 = qf1.l2 * qf2.l2;

    // Sumowanie z carry – to jest uproszczone, pełne quad-double wymaga więcej carry
    var real_part = p1;
    var carry = p2 + p3 + p4 + p5 + p6 + p7 + p8 + p9 + p10 + p11 + p12 + p13 + p14 + p15 + p16;
    real_part += carry;

    // Dokładne carry do low części – uproszczone
    return quadfloat_from_real(real_part);
}

// 4. sqr – kwadrat (optymalizacja mul)
function quadfloat_sqr(qf)
{
    return quadfloat_mul(qf, qf);
}

// 5. qrt – x^4 = (x²)²
function quadfloat_qrt(qf)
{
    var sq = quadfloat_sqr(qf);
    return quadfloat_sqr(sq);
}


// 6. inverse (1/x) – Newton-Raphson lub approx
function quadfloat_inverse(qf)
{
    // Proste przybliżenie Newtona (1/x ≈ 1/h1, potem iteracja)
    var inv_high = 1.0 / qf.h1;
    var inv = quadfloat_from_real(inv_high);
    // Iteracja Newtona – 1–2 iteracje wystarczą
    var one = quadfloat_from_real(1.0);
    var err = quadfloat_add(one, quadfloat_mul(quadfloat_neg(qf), inv));
    var correction = quadfloat_mul(inv, err);
    inv = quadfloat_add(inv, correction);
    return inv;
}

// 7. neg – flip znaku
function quadfloat_neg(qf)
{
    return { h1: -qf.h1, h2: -qf.h2, l1: -qf.l1, l2: -qf.l2 };
}

// 8. sqrt – aproksymacja (Newton)
function quadfloat_sqrt(qf)
{
    var xx = quadfloat_from_real(sqrt(qf.h1));
    for (var iter = 0; iter < 3; iter++) 
		{
	        var err = quadfloat_add(qf, quadfloat_mul(quadfloat_neg(xx), xx));
	        var correction = quadfloat_mul(xx, err);
	        xx = quadfloat_add(xx, correction);
	    }
    return xx;
}

function quad_max_eps(qf, quad_eps)
{
    // Porównujemy qf z quad_eps (struktura quadfloat)
    // Najprostsze: jeśli qf.h1 < quad_eps.h1 → bierzemy quad_eps
    // ale dokładniej: porównujemy moduł qf z quad_eps

    var qf_abs = quadfloat_abs(qf);  // zakładamy, że masz abs (neg + abs)

    // Proste porównanie high części
    if (qf_abs.h1 < quad_eps.h1) {
        return quad_eps;
    }

    // Jeśli high równe – porównujemy low
    if (qf_abs.h1 == quad_eps.h1) {
        if (qf_abs.h2 < quad_eps.h2) {
            return quad_eps;
        }
        if (qf_abs.h2 == quad_eps.h2) {
            if (qf_abs.l1 < quad_eps.l1) {
                return quad_eps;
            }
            if (qf_abs.l1 == quad_eps.l1) {
                if (qf_abs.l2 < quad_eps.l2) {
                    return quad_eps;
                }
            }
        }
    }

    return qf_abs;
}


// Pomocnicza abs (dla quadfloat)
function quadfloat_abs(qf)
{
    return {
        h1 : abs(qf.h1),
        h2 : abs(qf.h2),
        l1 : abs(qf.l1),
        l2 : abs(qf.l2)
    };
}


function quadfloat_greater(qf1, qf2)
{
    if (qf1.h1 > qf2.h1) return true;
    if (qf1.h1 < qf2.h1) return false;

    if (qf1.h2 > qf2.h2) return true;
    if (qf1.h2 < qf2.h2) return false;

    if (qf1.l1 > qf2.l1) return true;
    if (qf1.l1 < qf2.l1) return false;

    if (qf1.l2 > qf2.l2) return true;
    return false;
}

function quadfloat_div(qf1, qf2)
{
    var inv_qf2 = quadfloat_inverse(qf2);
    return quadfloat_mul(qf1, inv_qf2);
}

function quadfloat_equal(qf1, qf2)
{
    return (qf1.h1 == qf2.h1 &&
            qf1.h2 == qf2.h2 &&
            qf1.l1 == qf2.l1 &&
            qf1.l2 == qf2.l2);
}

function quadfloat_equal_in_eps(qf1, qf2, dim, tolerance) // tolerance = ile eps dywergencji max
{
    var quad_eps = get_quad_epsilon(dim);  // eps wymiarowy

    var diff = quadfloat_add(qf1, quadfloat_neg(qf2));  // qf1 - qf2

    var abs_diff = quadfloat_abs(diff);  // flip sign abs

    var dywergencja = quadfloat_div(abs_diff, quad_eps);  // dywergencja = |qf1 - qf2| / eps

    // Oblicz ile eps wchodzi w sumę (dywergencja.h1 + dywergencja.h2 + dywergencja.l1 + dywergencja.l2)
    var sum_dywerg = dywergencja.h1 + dywergencja.h2 + dywergencja.l1 + dywergencja.l2;

    if (sum_dywerg > tolerance) {
        show_debug_message("FAIL: Dywer gencja > tolerance: " + string(sum_dywerg));
        return false;
    }

    return true;
}

function quadfloat_to_string(qf, mode, digits) // mode "full" or "exp", digits dla zaokrągl mantysy
{
    var sum = qf.h1 + qf.h2 * (1 / (1 << 53)) + qf.l1 * (1 / (1 << 106)) + qf.l2 * (1 / (1 << 159));

    if (mode == "full") {
        return string_format(sum, 0, 50);  // pełna liczba z 50 cyframi
    } else if (mode == "exp") {
        if (sum == 0) return "0";
        var abs_sum = abs(sum);
        var order = floor(log10(abs_sum));
        var mantysa = sum / power(10, order);
        var mantysa_round = round(mantysa * power(10, digits - 1)) / power(10, digits - 1);
        return string(mantysa_round) + "e" + string(order);
    }
    return "0";
}



