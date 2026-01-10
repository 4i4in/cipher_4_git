function f_complex_compression_1_2(_ny_vec)
{
    var quad_eps = get_quad_epsilon(2);  // dla C2D

    var _nomr_rest = quad_max_eps(
        quadfloat_from_real(1.0 - sqr(_ny_vec._0)),
        quad_eps
    );

    var sum_b_sq = sqr(_ny_vec._1);
    var sum_b_quad = quadfloat_from_real(sum_b_sq);

    if (quadfloat_greater(sum_b_quad, quad_eps)) {
        return quadfloat_sqrt(
            quadfloat_div(_nomr_rest, sum_b_quad)
        );
    } else {
        return quadfloat_from_real(0.0);
    }
}

function f_quat_compression_1_4(_ny_vec)
{
    var quad_eps = get_quad_epsilon(4);  // dla ℍ4

    var _nomr_rest = quad_max_eps(
        quadfloat_from_real(1.0 - (sqr(_ny_vec._0) + sqr(_ny_vec._1))),
        quad_eps
    );

    var sum_cd_sq = sqr(_ny_vec._2) + sqr(_ny_vec._3);
    var sum_cd_quad = quadfloat_from_real(sum_cd_sq);

    if (quadfloat_greater(sum_cd_quad, quad_eps)) {
        return quadfloat_sqrt(
            quadfloat_div(_nomr_rest, sum_cd_quad)
        );
    } else {
        return quadfloat_from_real(0.0);
    }
}

function f_okt_compression_1_8(_ny_vec)
{
    var quad_eps = get_quad_epsilon(8);  // dla 𝕆8

    var _nomr_rest = quad_max_eps(
        quadfloat_from_real(1.0 - (sqr(_ny_vec._0) + sqr(_ny_vec._1) + sqr(_ny_vec._2) + sqr(_ny_vec._3))),
        quad_eps
    );

    var sum_efgh_sq = sqr(_ny_vec._4) + sqr(_ny_vec._5) + sqr(_ny_vec._6) + sqr(_ny_vec._7);
    var sum_efgh_quad = quadfloat_from_real(sum_efgh_sq);

    if (quadfloat_greater(sum_efgh_quad, quad_eps)) {
        return quadfloat_sqrt(
            quadfloat_div(_nomr_rest, sum_efgh_quad)
        );
    } else {
        return quadfloat_from_real(0.0);
    }
}

function f_sed_compression_1_16(_ny_vec)
{
    var quad_eps = get_quad_epsilon(16);  // dla 𝕊16

    var _nomr_rest = quad_max_eps(
        quadfloat_from_real(1.0 - (sqr(_ny_vec._0) + sqr(_ny_vec._1) + sqr(_ny_vec._2) + sqr(_ny_vec._3) + sqr(_ny_vec._4) + sqr(_ny_vec._5) + sqr(_ny_vec._6) + sqr(_ny_vec._7))),
        quad_eps
    );

    var sum_ijkl_sq = sqr(_ny_vec._8) + sqr(_ny_vec._9) + sqr(_ny_vec._10) + sqr(_ny_vec._11) + sqr(_ny_vec._12) + sqr(_ny_vec._13) + sqr(_ny_vec._14) + sqr(_ny_vec._15);
    var sum_ijkl_quad = quadfloat_from_real(sum_ijkl_sq);

    if (quadfloat_greater(sum_ijkl_quad, quad_eps)) {
        return quadfloat_sqrt(
            quadfloat_div(_nomr_rest, sum_ijkl_quad)
        );
    } else {
        return quadfloat_from_real(0.0);
    }
}