use facade::f;

#[test]
fn test_f() {
    let x = 1_u8;
    assert_eq!(f(x), x);
}
