# You will need to adjust this for each project. 
project_name := "code_cov_demo"

build_js:
  gleam build --target=javascript

test_js:
  gleam test --target=javascript

cov_js: build_js
  #!/usr/bin/env bash
  set -euxo pipefail

  COV_DIR=_coverage

  [[ -d "${COV_DIR}" ]] && rm -r "${COV_DIR}"
  mkdir -p "${COV_DIR}"

  TEST_RUNNER=./"${COV_DIR}"/test_runner.mjs
  
  cat << EOF > "${TEST_RUNNER}"
    import { test } from "node:test";
    import { main } from "../build/dev/javascript/{{ project_name }}/{{ project_name }}_test.mjs";
    test("suite", (_) => {
      main();
    })
  EOF

  cat "${TEST_RUNNER}" 

  # Run tests with coverage.
  node \
    --test \
    --experimental-test-coverage \
    --test-reporter=lcov  \
    --test-reporter-destination="./${COV_DIR}/cov_full.lcov" \
    "${TEST_RUNNER}"

  # Select files from this project.
  lcov \
    --extract "./${COV_DIR}/cov_full.lcov" '*{{ project_name }}*' \
    --output-file="./${COV_DIR}/cov_project.lcov"

  # Reject the actual test files from coverage report.
  lcov \
    --remove "./${COV_DIR}/cov_project.lcov" '*_test.mjs' \
    --output-file="./${COV_DIR}/cov_project_no_test.lcov"

  # Generate the html report.
  genhtml \
    --output-directory="./${COV_DIR}/html" \
    "./${COV_DIR}/cov_project_no_test.lcov"

  REPORT="./${COV_DIR}/html/index.html"

  [[ -f "${REPORT}" ]] && printf "report: ${REPORT}\n"
