import code_cov_demo/magic/magic_math as math
import gleeunit/should

pub fn add_test() {
  math.add(1, 2) |> should.equal(3)
}

pub fn add2_test() {
  math.add(10, 20) |> should.equal(30)
}
