import code_cov_demo/magic/magic_string as string
import gleeunit/should

pub fn concat_test() {
  string.concat("a", "b") |> should.equal("ab")
}
