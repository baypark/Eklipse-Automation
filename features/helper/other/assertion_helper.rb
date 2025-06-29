class AssertionError < StandardError; end

=begin
 Asserts that the given value is true
 If the value is not true, it raises an AssertionError
 @param actual [Boolean] The value to be asserted
=end
def assert_true(actual)
  raise AssertionError, "Expected true but got #{actual}" unless actual == true
  true
rescue AssertionError => e
  handle_assertion_error(e, actual)
end

=begin
 Asserts that the given value is false
 If the value is not false, it raises an AssertionError
 @param actual [Boolean] The value to be asserted
=end
def assert_false(actual)
  raise AssertionError, "Expected false but got #{actual}" unless actual == false
  false
rescue AssertionError => e
  handle_assertion_error(e, actual)
end

=begin
 Asserts that the given actual value matches the expected value
 If the values do not match, it raises an AssertionError
 @param expected [Object] The expected value
 @param actual [Object] The actual value to be asserted
=end
def assert_match(expected, actual)
  raise AssertionError, "Data #{expected.inspect} isn't match with actual -> #{actual.inspect}" unless expected === actual
rescue AssertionError => e
  handle_assertion_error(e, actual, expected)
end

private

def handle_assertion_error(e, actual, expected = nil)
  message = expected ? "Error on matching the object.\nactual: #{actual.inspect},\nexpected: #{expected.inspect}" : "Error! actual result is '#{actual}'"
  puts message
  exit(false)
end
