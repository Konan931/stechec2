function assert(cond) {
    if (cond != true) throw new Error();
}

function range(m, n) {
    return Array(n - m).fill().map((_, i) => m + i);
}

function deepEqual(a, b) {
    if (Array.isArray(a)) {
        if (!Array.isArray(b) || a.length !== b.length) return false;
        for (let i = 0; i < a.length; i++) {
            if (!deepEqual(a[i], b[i])) return false;
        }
        return true;
    }
    else if (typeof(a) === 'object') {
        if (typeof(b) !== 'object') return false;
        for (const k in a) {
            if (!deepEqual(a[k], b[k])) return false;
        }
        for (const k in b) {
            if (!deepEqual(a[k], b[k])) return false;
        }
        return true;
    }
    else return a === b;
}

function testAlert() {
    assert(false);
}

function test() {
    assert(CONST_VAL === 42);
    assert(CONST_DOUBLE === 42.42);
    assert(CONST_STR === "TTY");
    
    sendMe42(42);
    sendMe42And1337(42, 1337);
    sendMeTrue(true);
    sendMeTau(6.2831853);
    sendMeJosephMarchand("Joseph Marchand");
    sendMe13Ints(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13);

    assert(returns42() === 42);
    assert(returnsTrue() === true);
    assert(Math.abs(returnsTau() - 6.2831853) < 0.0001);
    assert(returnsJosephMarchand() === "Joseph Marchand");
    assert(returnsVal1() === TestEnum.Val1);
    assert(returnsVal1() !== TestEnum.Val2);
    assert(deepEqual(returnsRange(1, 100), range(1, 100)));
    assert(deepEqual(returnsRange(1, 10000), range(1, 10000)));
    assert(deepEqual(returnsSorted([1, 3, 2, 4, 5, 7, 6]), [1, 2, 3, 4, 5, 6, 7]));
    assert(deepEqual(returnsSorted(range(1, 10000)), range(1, 10000)));
    assert(deepEqual(returnsNot(Array(9).fill().map((_, i) => i % 3 === 0)), Array(9).fill().map((_, i) => i % 3 !== 0)));
    assert(deepEqual(returnsInverse([-0.5, 1, 12.5, 42]), [-2, 1, 0.08, 0.023809523809523808]));
    assert(deepEqual(returnsReversedEnums([TestEnum.Val1, TestEnum.Val2, TestEnum.Val2]), [TestEnum.Val2, TestEnum.Val2, TestEnum.Val1]));
    assert(deepEqual(returnsUpper(["Alea", "Jacta", "Est"]), ["ALEA", "JACTA", "EST"]));
    
    const simpleStr = {
        fieldI: 42,
        fieldBool: true,
        fieldDouble: 42.42,
        fieldString: "TTY"
    };
    const simpleTup = [42, true];
    const struct42s = {
        fieldInt: 42,
        fieldIntArr: Array(42).fill(42),
        fieldStrArr: Array(42).fill(simpleStr),
        fieldTupArr: Array(42).fill(simpleTup)
    };
    sendMeSimple(simpleStr);
    sendMe42s(struct42s);
    sendMeDoubleStruct({
        fieldOne: 42.42,
        fieldTwo: 42.42
    });
    sendMeTupleStruct(simpleTup);
    sendMeTestEnum(TestEnum.Val1, TestEnum.Val2);
    afficherTestEnum(TestEnum.Val2);
    sendMeStructWithStruct({
        fieldInteger: 42,
        fieldStruct: simpleStr,
        fieldTuple: simpleTup
    });
    sendMeTupleWithStruct([42, simpleStr, simpleTup]);
    assert(deepEqual(sendMeStructArray(Array(42).fill(struct42s)), Array(42).fill(struct42s)));
    sendMeTupleWithArray([42, Array(42).fill(simpleTup)]);
}
