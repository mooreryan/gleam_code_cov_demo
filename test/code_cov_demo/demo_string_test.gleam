import code_cov_demo/demo_string as string
import gleeunit/should

pub fn concat_test() {
  string.concat("a", "b") |> should.equal("ab")
}
