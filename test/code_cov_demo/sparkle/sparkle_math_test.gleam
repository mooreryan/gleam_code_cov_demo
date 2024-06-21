import code_cov_demo/sparkle/sparkle_math as math
import gleeunit/should

pub fn add_test() {
  math.add(1, 2) |> should.equal(3)
}
