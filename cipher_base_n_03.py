from mpmath import mp, mpf, sqrt, power, cos, sin, log, asin, pi, floor
import random
import copy
import time
import hashlib

# Ustawiamy wysoką precyzję w mpmath, np. 256 bitów (około 77 cyfr dziesiętnych)
mp.dps = 77  # Dla 256 bitów precyzji; możesz zwiększyć do np. 1000 dla większych kluczy

# Stałe
num_32_max = mpf('4294967295')
phi_input = mpf(2) * pi
EPSILON = mpf('1e-10')  # Przybliżone epsilon dla porównań

# Proste wektory jako dicty
simple_f_vec16 = {
    '_0': mpf(0), '_1': mpf(0), '_2': mpf(0), '_3': mpf(0),
    '_4': mpf(0), '_5': mpf(0), '_6': mpf(0), '_7': mpf(0),
    '_8': mpf(0), '_9': mpf(0), '_10': mpf(0), '_11': mpf(0),
    '_12': mpf(0), '_13': mpf(0), '_14': mpf(0), '_15': mpf(0)
}

simple_f_vec8 = {
    '_0': mpf(0), '_1': mpf(0), '_2': mpf(0), '_3': mpf(0),
    '_4': mpf(0), '_5': mpf(0), '_6': mpf(0), '_7': mpf(0)
}

# Lista liczb pierwszych (z oryginału, zakładam prime_list z GMS)
prime_list = [
    3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,
    79,83,89,97,101,103,107,109,113,127,131,137,139,149,151,157,
    163,167,173,179,181,191,193,197,199,211,223,227,229,233,239,
    241,251,257,263,269,271,277,281,283,293,307,311,313,317,331,
    337,347,349,353,359,367,373,379,383,389,397,401,409,419,421,
    431,433,439,443,449,457,461,463,467,479,487,491,499,503,509,
    521,523,541,547,557,563,569,571,577,587,593,599,601,607,613,
    617,619,631,641,643,647,653,659,661,673,677,683,691,701,709,
    719,727,733,739,743,751,757,761,769,773,787,797,809,811,821,
    823,827,829,839,853,857,859,863,877,881,883,887,907,911,919,
    929,937,941,947,953,967,971,977,983,991,997,1009,1013,1019,
    1021,1031,1033,1039,1049,1051,1061,1063,1069,1087,1091,1093,
    1097,1103,1109,1117,1123,1129,1151,1153,1163,1171,1181,1187,
    1193,1201,1213,1217,1223,1229,1231,1237,1249,1259,1277,1279,
    1283,1289,1291,1297,1301,1303,1307,1319,1321,1327,1361,1367,
    1373,1381,1399,1409,1423,1427,1429,1433,1439,1447,1451,1453,
    1459,1471,1481,1483,1487,1489,1493,1499,1511,1523,1531,1543,
    1549,1553,1559,1567,1571,1579,1583,1597,1601,1607,1609,1613,
    1619,1621,1627,1637,1657,1663,1667,1669,1693,1697,1699,1709,
    1721,1723,1733,1741,1747,1753,1759,1777,1783,1787,1789,1801,
    1811,1823,1831,1847,1861,1867,1871,1873,1877,1879,1889,1901,
    1907,1913,1931,1933,1949,1951,1973,1979,1987,1993,1997,1999,
    2003,2011,2017,2027,2029,2039,2053,2063,2069,2081,2083,2087,
    2089,2099,2111,2113,2129,2131,2137,2141,2143,2153,2161,2179,
    2203,2207,2213,2221,2237,2239,2243,2251,2267,2269,2273,2281,
    2287,2293,2297,2309,2311,2333,2339,2341,2347,2351,2357,2371,
    2377,2381,2383,2389,2393,2399,2411,2417,2423,2437,2441,2447,
    2459,2467,2473,2477,2503,2521,2531,2539,2543,2549,2551,2557,
    2579,2591,2593,2609,2617,2621,2633,2647,2657,2659,2663,2671,
    2677,2683,2687,2689,2693,2699,2707,2711,2713,2719,2729,2731,
    2741,2749,2753,2767,2777,2789,2791,2797,2801,2803,2819,2833,
    2837,2843,2851,2857,2861,2879,2887,2897,2903,2909,2917,2927,
    2939,2953,2957,2963,2969,2971,2999,3001,3011,3019,3023,3037,
    3041,3049,3061,3067,3079,3083,3089,3109,3119,3121,3137,3163,
    3167,3169,3181,3187,3191,3203,3209,3217,3221,3229,3251,3253,
    3257,3259,3271,3299,3301,3307,3313,3319,3323,3329,3331,3343,
    3347,3359,3361,3371,3373,3389,3391,3407,3413,3433,3449,3457,
    3461,3463,3467,3469,3491,3499,3511,3517,3527,3529,3533,3539,
    3541,3547,3557,3559,3571,3581,3583,3593,3607,3613,3617,3623,
    3631,3637,3643,3659,3671,3673,3677,3691,3697,3701,3709,3719,
    3727,3733,3739,3761,3767,3769,3779,3793,3797,3803,3821,3823,
    3833,3847,3851,3853,3863,3877,3881,3889,3907,3911,3917,3919,
    3923,3929,3931,3943,3947,3967,3989,4001,4003,4007,4013,4019,
    4021,4027,4049,4051,4057,4073,4079,4091,4093,4099,4111,4127,
    4129,4133,4139,4153,4157,4159,4177,4201,4211,4217,4219,4229,
    4231,4241,4243,4253,4259,4261,4271,4273,4283,4289,4297,4327,
    4337,4339,4349,4357,4363,4373,4391,4397,4409,4421,4423,4441,
    4447,4451,4457,4463,4481,4483,4493,4507,4513,4517,4519,4523,
    4547,4549,4561,4567,4583,4591,4597,4603,4621,4637,4639,4643,
    4649,4651,4657,4663,4673,4679,4691,4703,4721,4723,4729,4733,
    4751,4759,4783,4787,4789,4793,4799,4801,4813,4817,4831,4861,
    4871,4877,4889,4903,4909,4919,4931,4933,4937,4943,4951,4957,
    4967,4969,4973,4987,4993,4999,5003,5009,5011,5021,5023,5039,
    5051,5059,5077,5081,5087,5099,5101,5107,5113,5119,5147,5153,
    5167,5171,5179,5189,5197,5209,5227,5231,5233,5237,5261,5273,
    5279,5281,5297,5303,5309,5323,5333,5347,5351,5381,5387,5393,
    5399,5407,5413,5417,5419,5431,5437,5441,5443,5449,5471,5477,
    5479,5483,5501,5503,5507,5519,5521,5527,5531,5557,5563,5569,
    5573,5581,5591,5623,5639,5641,5647,5651,5653,5657,5659,5669,
    5683,5689,5693,5701,5711,5717,5737,5741,5743,5749,5779,5783,
    5791,5801,5807,5813,5821,5827,5839,5843,5849,5851,5857,5861,
    5867,5869,5879,5881,5897,5903,5923,5927,5939,5953,5981,5987,
    6007,6011,6029,6037,6043,6047,6053,6067,6073,6079,6089,6091,
    6101,6113,6121,6131,6133,6143,6151,6163,6173,6197,6199,6203,
    6211,6217,6221,6229,6247,6257,6263,6269,6271,6277,6287,6299,
    6301,6311,6317,6323,6329,6337,6343,6353,6359,6361,6367,6373,
    6379,6389,6397,6421,6427,6449,6451,6469,6473,6481,6491,6521,
    6529,6547,6551,6553,6563,6569,6571,6577,6581,6599,6607,6619,
    6637,6653,6659,6661,6673,6679,6689,6691,6701,6703,6709,6719,
    6733,6737,6761,6763,6779,6781,6791,6793,6803,6823,6827,6829,
    6833,6841,6857,6863,6869,6871,6883,6899,6907,6911,6917,6947,
    6949,6959,6961,6967,6971,6977,6983,6991,6997,7001,7013,7019,
    7027,7039,7043,7057,7069,7079,7103,7109,7121,7127,7129,7151,
    7159,7177,7187,7193,7207,7211,7213,7219,7229,7237,7243,7247,
    7253,7283,7297,7307,7309,7321,7331,7333,7349,7351,7369,7393,
    7411,7417,7433,7451,7457,7459,7477,7481,7487,7489,7499,7507,
    7517,7523,7529,7537,7541,7547,7549,7559,7561,7573,7577,7583,
    7589,7591,7603,7607,7621,7639,7643,7649,7669,7673,7681,7687,
    7691,7699,7703,7717,7723,7727,7741,7753,7757,7759,7789,7793,
    7817,7823,7829,7841,7853,7867,7873,7877,7879,7883,7901,7907,
    7919]  # ~170 liczb – spokojnie starczy na 256 rund

def f_quat_add(q1, q2):
    return {
        '_0': q1['_0'] + q2['_0'],
        '_1': q1['_1'] + q2['_1'],
        '_2': q1['_2'] + q2['_2'],
        '_3': q1['_3'] + q2['_3']
    }

def f_quat_sub(q1, q2):
    return {
        '_0': q1['_0'] - q2['_0'],
        '_1': q1['_1'] - q2['_1'],
        '_2': q1['_2'] - q2['_2'],
        '_3': q1['_3'] - q2['_3']
    }

def f_quat_mul(q1, q2):
    result = {
        '_0': q1['_0'] * q2['_0'] - q1['_1'] * q2['_1'] - q1['_2'] * q2['_2'] - q1['_3'] * q2['_3'],
        '_1': q1['_0'] * q2['_1'] + q1['_1'] * q2['_0'] + q1['_2'] * q2['_3'] - q1['_3'] * q2['_2'],
        '_2': q1['_0'] * q2['_2'] - q1['_1'] * q2['_3'] + q1['_2'] * q2['_0'] + q1['_3'] * q2['_1'],
        '_3': q1['_0'] * q2['_3'] + q1['_1'] * q2['_2'] - q1['_2'] * q2['_1'] + q1['_3'] * q2['_0']
    }
    return result

def f_quat_conj(quat):
    conj = copy.deepcopy(quat)
    conj['_0'] = quat['_0']
    conj['_1'] = -quat['_1']
    conj['_2'] = -quat['_2']
    conj['_3'] = -quat['_3']
    return conj

def f_split_okt_to_2h(vec8):
    ret = {'_a': {}, '_b': {}}
    for i in range(4):
        new_name = '_' + str(i)
        value = vec8['_' + str(i)]
        ret['_a'][new_name] = value
    for i in range(4, 8):
        new_name = '_' + str(i - 4)
        value = vec8['_' + str(i)]
        ret['_b'][new_name] = value
    return ret

def f_okt_add(okt1, okt2):
    sum_okt = {}
    for i in range(8):
        key = '_' + str(i)
        value = okt1[key] + okt2[key]
        sum_okt[key] = value
    return sum_okt

def f_okt_sub(okt1, okt2):
    diff = {}
    for i in range(8):
        key = '_' + str(i)
        value = okt1[key] - okt2[key]
        diff[key] = value
    return diff

def f_okt_mul(vec8_R, vec8_Q):
    ret_R_2h4 = f_split_okt_to_2h(vec8_R)
    Ro_a = ret_R_2h4['_a']
    Ro_b = ret_R_2h4['_b']
    
    ret_Q_2h4 = f_split_okt_to_2h(vec8_Q)
    Qo_c = ret_Q_2h4['_a']
    Qo_d = ret_Q_2h4['_b']
    
    conj_Qc = f_quat_conj(Qo_c)
    conj_Qd = f_quat_conj(Qo_d)
    
    term1 = f_quat_mul(Ro_a, Qo_c)
    term2 = f_quat_mul(conj_Qd, Ro_b)
    real_part = f_quat_sub(term1, term2)
    
    term3 = f_quat_mul(Qo_d, Ro_a)
    term4 = f_quat_mul(Ro_b, conj_Qc)
    imag_part = f_quat_add(term3, term4)
    
    result = copy.deepcopy(simple_f_vec8)
    
    for i in range(4):
        key = '_' + str(i)
        value = real_part[key]
        result[key] = value
    
    for i in range(4):
        key = '_' + str(i + 4)
        subkey = '_' + str(i)
        value = imag_part[subkey]
        result[key] = value
    
    return result

def f_conj_okt(oktonion):
    conj = copy.deepcopy(oktonion)
    conj['_0'] = oktonion['_0']
    for i in range(1, 8):
        key = '_' + str(i)
        conj[key] = -oktonion[key]
    return conj

def f_split_sed_to_2o(vec16):
    ret = {'_a': {}, '_b': {}}
    for i in range(8):
        new_name = '_' + str(i)
        value = vec16['_' + str(i)]
        ret['_a'][new_name] = value
    for i in range(8, 16):
        new_name = '_' + str(i - 8)
        value = vec16['_' + str(i)]
        ret['_b'][new_name] = value
    return ret

def sedenion_multiply(vec16_R, vec16_Q):
    ret_R_2o8 = f_split_sed_to_2o(vec16_R)
    Ro_a = ret_R_2o8['_a']
    Ro_b = ret_R_2o8['_b']
    
    ret_Q_2o8 = f_split_sed_to_2o(vec16_Q)
    Qo_c = ret_Q_2o8['_a']
    Qo_d = ret_Q_2o8['_b']
    
    conj_Qo_c = f_conj_okt(Qo_c)
    conj_Qo_d = f_conj_okt(Qo_d)
    
    term1 = f_okt_mul(Ro_a, Qo_c)
    term2 = f_okt_mul(conj_Qo_d, Ro_b)
    result_real = f_okt_sub(term1, term2)
    
    term3 = f_okt_mul(Qo_d, Ro_a)
    term4 = f_okt_mul(Ro_b, conj_Qo_c)
    result_imag = f_okt_add(term3, term4)
    
    result = copy.deepcopy(simple_f_vec16)
    for i in range(8):
        key = '_' + str(i)
        result[key] = result_real[key]
        key_imag = '_' + str(i + 8)
        result[key_imag] = result_imag[key]
    return result

def single_euclid_rot_16(s_vec_16, cos_phi, sin_phi, reason):
    if reason == "cipher":
        sin_phi /= sqrt(mpf(15))
    if reason == "decipher":
        sin_phi = -sin_phi / sqrt(mpf(15))
    
    R = copy.deepcopy(simple_f_vec16)
    R['_0'] = cos_phi
    
    for i in range(1, 16):
        R['_' + str(i)] = sin_phi
    
    s_vec_16 = sedenion_multiply(R, s_vec_16)
    
    return s_vec_16

def exe_return_base_fraction(key_max, key, rounds):
    left_side = mpf(key)  # To jest bardzo ważne w kontekście phy!!! patrz notatka!
    right_side = sqrt(mpf(key))
    for i in range(0, rounds, 2):
        left_side += power(mpf(key), mpf(1) / mpf(prime_list[i]))
        if i + 1 < rounds:
            right_side += power(mpf(key), mpf(1) / mpf(prime_list[i + 1]))
    base_fraction = left_side / right_side
    print("_left_side :", left_side)
    print("_right_side :", right_side)
    print("base_fraction :", base_fraction)
    return base_fraction

def return_scale_of_simple_16(ny_vec):
    sum_16_sq = mpf(0)
    for i in range(16):
        sum_16_sq += ny_vec['_' + str(i)] ** 2
    
    if abs(mpf(1) - sum_16_sq) > EPSILON:
        return mpf(1) / sqrt(sum_16_sq)
    else:
        return mpf(1)

def f_scale_QCO_Like_v2(s_vec_16, dir, key):
    pool = list(range(16))
    seed = int(key)  # Klucz jako int
    for s in range(16):
        # Symulacja LCG z GMS: seed = (seed * 0x5DEECE66D + 11) % 2**48
        seed = (seed * 0x5DEECE66D + 11) % (2 ** 48)
        random.seed(seed)
        random.shuffle(pool)
    
    pow_val = 2
    while pow_val < 16:
        for i in range(pow_val, pow_val * 2):
            if i < len(pool):
                n = pool[i]
                if dir == "fwd":
                    s_vec_16['_' + str(n)] = power(s_vec_16['_' + str(n)], mpf(pow_val))
                elif dir == "rev":
                    s_vec_16['_' + str(n)] = power(s_vec_16['_' + str(n)], mpf(1) / mpf(pow_val))
        pow_val *= 2
    return s_vec_16

def exe_spawn_random_message(s_vec_16):
    random.seed()  # Randomize
    for i in range(16):
        s_vec_16['_' + str(i)] = mpf(random.randint(0, int(num_32_max)))
    return s_vec_16

def exe_create_random_key(key_length):
    key_max = (1 << key_length) - 1  # power(2, key_length) - 1, ale int w Pythonie obsługuje duże liczby
    if key_length > 32:
        return random.randint(0, key_max)
    return key_max + random.randint(0, key_max)

def exe_decrypt_msg_v2(cipher, key_max, key, rounds):
    scale = cipher['scale']
    s_vec_16 = cipher['msg']
    
    base_fraction = exe_return_base_fraction(key_max, key, rounds)
    fract_list = {}
    for r in range(rounds):
        fraction = copy.deepcopy(base_fraction)
        fraction = exe_return_fraction(key, r, fraction, rounds)
        sname = '_' + str(r)
        fract_list[sname] = copy.deepcopy(fraction)
    
    for r in range(rounds - 1, -1, -1):
        sname = '_' + str(r)
        phi = phi_input * fract_list[sname]  # koniugacja: -phi, ale w sin/cos obsługiwane poniżej
        cos_phi = cos(phi)
        sin_phi = sin(phi)
        s_vec_16 = single_euclid_rot_16(s_vec_16, cos_phi, sin_phi, "decipher")
    
    # retrieve scale
    for i in range(16):
        s_vec_16['_' + str(i)] /= scale
    
    s_vec_16 = f_scale_QCO_Like_v2(s_vec_16, "rev", key)
    
    # retrieve integers
    for i in range(16):
        s_vec_16['_' + str(i)] = floor(s_vec_16['_' + str(i)] * num_32_max)
    
    return s_vec_16

def exe_return_fraction(key, r, fraction, rounds):
    # Hash jak w GMS2 – string_unicode ≈ utf-16le
    input_str = f"{key}{r}".encode('utf-16le')
    hash_obj = hashlib.sha1(input_str)
    hash_hex = hash_obj.hexdigest()  # 40 znaków hex

    # string_ord_at – pozycje 1-based
    a = int(hash_hex[0:2], 16)        # pozycja 1
    b = int(hash_hex[32:34], 16)      # pozycja 17
    c = int(hash_hex[24:26], 16)      # pozycja 13

    small = mpf(((a ^ b) % 211 - 101)) / 1009
    tiny  = mpf(((c ^ b) % 53  - 29))  / 1279

    typ = int((c ^ a) + rounds) % 4

    if typ == 0:
        fraction = fraction + mpf(r) * (mpf('0.1') + small - tiny)

    elif typ == 1:
        low  = mpf('-1') + abs(tiny)
        high = mpf('1')  - abs(tiny)
        fraction = fraction * small * tiny * tiny
        fraction = max(low, min(high, fraction))
        fraction = max(mpf('-1'), min(mpf('1'), fraction))  # ŻELAZNA TARCZA
        fraction = asin(fraction)

    elif typ == 2:
        base = fraction - tiny
        # Najważniejsza poprawka – unikamy ujemnej/zerowej podstawy
        if base <= 0:
            base = abs(base) if base < 0 else mpf('1e-10')
        exponent = mpf(r) * (mpf('0.4') + small * mpf('0.2'))
        fraction = power(base, exponent)

    elif typ == 3:
        arg = fraction * (mpf(r) + mpf('7') + small * mpf('2'))
        log_base = mpf(rounds) - tiny
        if arg <= 0:
            arg = mpf('1e-10')
        if log_base <= 1:
            log_base = mpf('2')
        fraction = log(arg, log_base)

    return fraction
    
def exe_crypt_msg_v2(s_vec_16, key_max, key, rounds):
    # invert under 1
    for i in range(16):
        s_vec_16['_' + str(i)] /= num_32_max
    
    s_vec_16 = f_scale_QCO_Like_v2(s_vec_16, "fwd", key)
    
    # scaling to |norm|^2=1
    scale = return_scale_of_simple_16(s_vec_16)
    for i in range(16):
        s_vec_16['_' + str(i)] *= scale
    
    base_fraction = exe_return_base_fraction(key_max, key, rounds)
    for r in range(rounds):
        fraction = copy.deepcopy(base_fraction)
        fraction = exe_return_fraction(key, r, fraction, rounds)
        phi = phi_input * fraction
        cos_phi = cos(phi)
        sin_phi = sin(phi)
        s_vec_16 = single_euclid_rot_16(s_vec_16, cos_phi, sin_phi, "cipher")
    
    msg = {
        'scale': scale,
        'msg': s_vec_16
    }
    return msg

# Funkcja porównująca oryginalny i deszyfrowany tekst (z oryginału)
def compare_ori_deciph(copy_open_text, decipher):
    for i in range(16):
        if copy_open_text['_' + str(i)] != decipher['_' + str(i)]:
            return False
    return True

# Główny kod testowy
key_length = 256  # Twoja żądana długość, np. 256 bitów
key_max = (1 << key_length) - 1
key = exe_create_random_key(key_length)
# key = 5674703573754352  # Opcja manualna

print("_key_length :", key_length, "| _key_max :", key_max, "| _key :", key)

open_text = exe_spawn_random_message(copy.deepcopy(simple_f_vec16))
copy_open_text = copy.deepcopy(open_text)
print("_open_text :", open_text)

cipher = exe_crypt_msg_v2(open_text, key_max, key, key_length)
print("_cipher scale :", cipher['scale'])
print("_cipher :", cipher['msg'])

t1 = time.time()
for dt in range(key - 30, key + 31):
    print(f"try key : {dt}")
    decipher = exe_decrypt_msg_v2(cipher, key_max, dt, key_length)
    print("_open_text :", copy_open_text)
    print("_deci_text :", decipher)
    comp_text = compare_ori_deciph(copy_open_text, decipher)
    print("_comp_text :", comp_text)
    print("-" * 60)

print("elapsed time :", time.time() - t1)