defmodule Litmus.Type.StringTest do
  use ExUnit.Case, async: true
  doctest Litmus.Type.String

  alias Litmus.Type

  describe "validate_field/3" do
    test "validates property values of data based on their String schema definition in Type.String module" do
      field = "id"
      data = %{"id" => "1"}

      type = %Type.String{
        required: true
      }

      assert Type.String.validate_field(type, field, data) == {:ok, data}
    end
  end

  describe "minimum length validation" do
    test "returns :ok when length of field is more than or equal to min_length" do
      min_length = 3
      data = %{"id" => "abc"}

      schema = %{
        "id" => %Litmus.Type.String{
          required: true,
          min_length: min_length
        }
      }

      assert Litmus.validate(data, schema) == {:ok, data}
    end

    test "returns :ok when the value is nil and min_length is 0" do
      data = %{"id" => nil}

      schema = %{
        "id" => %Litmus.Type.String{
          min_length: 0
        }
      }

      assert Litmus.validate(data, schema) == {:ok, data}
    end

    test "returns :ok when the value is an empty string and min_length is 0" do
      data = %{"id" => ""}

      schema = %{
        "id" => %Litmus.Type.String{
          min_length: 0
        }
      }

      assert Litmus.validate(data, schema) == {:ok, data}
    end

    test "errors when length of field is less than min_length" do
      min_length = 3
      field = "id"
      data = %{"id" => "ab"}

      schema = %{
        "id" => %Litmus.Type.String{
          required: true,
          min_length: min_length
        }
      }

      assert Litmus.validate(data, schema) ==
               {:error,
                "#{field} length must be greater than or equal to #{min_length} characters"}
    end

    test "errors when value is nil and min_length is greater than 0" do
      min_length = 3
      field = "id"
      data = %{"id" => nil}

      schema = %{
        "id" => %Litmus.Type.String{
          min_length: min_length
        }
      }

      assert Litmus.validate(data, schema) ==
               {:error,
                "#{field} length must be greater than or equal to #{min_length} characters"}
    end

    test "does not error if the field is not provided and not required" do
      field = "id"
      data = %{}

      type = %Type.String{
        min_length: 3
      }

      assert Type.String.validate_field(type, field, data) == {:ok, data}
    end
  end

  describe "maximum length validation" do
    test "returns :ok when length of field is less than or equal to max_length" do
      max_length = 3
      data = %{"id" => "ab"}

      schema = %{
        "id" => %Litmus.Type.String{
          required: true,
          max_length: max_length
        }
      }

      assert Litmus.validate(data, schema) == {:ok, data}
    end

    test "returns :ok when the value is nil" do
      data = %{"id" => nil}

      schema = %{
        "id" => %Litmus.Type.String{
          max_length: 10
        }
      }

      assert Litmus.validate(data, schema) == {:ok, data}
    end

    test "returns :ok when the value is nil and the max length is 0" do
      data = %{"id" => nil}

      schema = %{
        "id" => %Litmus.Type.String{
          max_length: 0
        }
      }

      assert Litmus.validate(data, schema) == {:ok, data}
    end

    test "returns :ok when the value is an empty string and the max length is 0" do
      data = %{"id" => ""}

      schema = %{
        "id" => %Litmus.Type.String{
          max_length: 0
        }
      }

      assert Litmus.validate(data, schema) == {:ok, data}
    end

    test "errors when length of field is more than max_length" do
      max_length = 3
      field = "id"
      data = %{"id" => "abcd"}

      schema = %{
        "id" => %Litmus.Type.String{
          required: true,
          max_length: max_length
        }
      }

      assert Litmus.validate(data, schema) ==
               {:error, "#{field} length must be less than or equal to #{max_length} characters"}
    end
  end

  describe "exact length validation" do
    test "returns :ok when length of field is equal to length" do
      length = 3
      data = %{"id" => "abc"}

      schema = %{
        "id" => %Litmus.Type.String{
          required: true,
          length: length
        }
      }

      assert Litmus.validate(data, schema) == {:ok, data}
    end

    test "returns :ok when the value is an empty string and the length is 0" do
      length = 0
      data = %{"id" => ""}

      schema = %{
        "id" => %Litmus.Type.String{
          length: length
        }
      }

      assert Litmus.validate(data, schema) == {:ok, data}
    end

    test "returns :ok when the value is nil and the length is 0" do
      length = 0
      data = %{"id" => nil}

      schema = %{
        "id" => %Litmus.Type.String{
          length: length
        }
      }

      assert Litmus.validate(data, schema) == {:ok, data}
    end

    test "errors when length of field is not equal to length" do
      length = 3
      field = "id"
      data = %{"id" => "abcd"}

      schema = %{
        "id" => %Litmus.Type.String{
          required: true,
          length: length
        }
      }

      assert Litmus.validate(data, schema) ==
               {:error, "#{field} length must be #{length} characters"}
    end

    test "errors when the value is nil and length is greater than 0" do
      length = 3
      field = "id"
      data = %{"id" => nil}

      schema = %{
        "id" => %Litmus.Type.String{
          length: length
        }
      }

      assert Litmus.validate(data, schema) ==
               {:error, "#{field} length must be #{length} characters"}
    end

    test "errors when the length is 0 and the value is not empty or nil" do
      length = 0
      field = "id"
      data = %{"id" => "a"}

      schema = %{
        "id" => %Litmus.Type.String{
          length: length
        }
      }

      assert Litmus.validate(data, schema) ==
               {:error, "#{field} length must be #{length} characters"}
    end
  end

  describe "regex validation" do
    test "returns :ok when value matches the regex pattern" do
      data = %{"username" => "user123"}

      schema = %{
        "username" => %Litmus.Type.String{
          regex: %Litmus.Type.String.Regex{
            pattern: ~r/^[a-zA-Z0-9_]*$/,
            error_message: "username must be alphanumeric"
          }
        }
      }

      assert Litmus.validate(data, schema) == {:ok, data}
    end

    test "errors with custom error message when value does not match regex pattern" do
      data = %{"username" => "x@##1"}

      schema = %{
        "username" => %Litmus.Type.String{
          regex: %Litmus.Type.String.Regex{
            pattern: ~r/^[a-zA-Z0-9_]*$/,
            error_message: "username must be alphanumeric"
          }
        }
      }

      assert Litmus.validate(data, schema) == {:error, "username must be alphanumeric"}
    end

    test "errors with default error message when value does not match regex pattern" do
      data = %{"username" => "x@##1"}
      field = "username"

      schema = %{
        field => %Litmus.Type.String{
          regex: %Litmus.Type.String.Regex{
            pattern: ~r/^\d{3,}(?:[-\s]?\d*)?$/
          }
        }
      }

      assert Litmus.validate(data, schema) == {:error, "#{field} must be in a valid format"}
    end

    test "errors when the value is nil" do
      data = %{"username" => nil}
      field = "username"

      schema = %{
        field => %Litmus.Type.String{
          regex: %Litmus.Type.String.Regex{
            pattern: ~r/^\d{3,}(?:[-\s]?\d*)?$/
          }
        }
      }

      assert Litmus.validate(data, schema) == {:error, "#{field} must be in a valid format"}
    end
  end

  describe "included in list validation" do
    test "returns :ok when field is in list" do
      list = ["carlos", "benit", "ruben"]
      data = %{"name" => "benit"}

      schema = %{
        "name" => %Litmus.Type.String{
          required: true,
          included: list
        }
      }

      assert Litmus.validate(data, schema) == {:ok, data}
    end

    test "returns :error when the value is not in list" do
      data = %{"name" => nil}

      schema = %{
        "name" => %Litmus.Type.String{
          included: ["carlos", "benit", "ruben"]
        }
      }

      assert Litmus.validate(data, schema) == {:error, "name isn't into the list."}
    end
  end

  describe "trim extra whitespaces" do
    test "returns :ok with new parameters having trimmed values when trim is set to true" do
      data = %{"id" => " abc "}
      trimmed_data = %{"id" => "abc"}

      schema = %{
        "id" => %Litmus.Type.String{
          trim: true
        }
      }

      assert Litmus.validate(data, schema) == {:ok, trimmed_data}
    end

    test "returns :ok with same parameters when trim is set to false" do
      data = %{"id" => " abc "}

      schema = %{
        "id" => %Litmus.Type.String{
          trim: false
        }
      }

      assert Litmus.validate(data, schema) == {:ok, data}
    end

    test "does not error when the value is nil" do
      data = %{"id" => nil}

      schema = %{
        "id" => %Litmus.Type.String{
          trim: true
        }
      }

      assert Litmus.validate(data, schema) == {:ok, data}
    end
  end

  describe "replace" do
    test "replaces a pattern in a string with a new string" do
      data = %{"username" => "user123"}
      modified_data = %{"username" => "anonymous"}

      schema = %{
        "username" => %Litmus.Type.String{
          replace: %Litmus.Type.String.Replace{
            pattern: ~r/^user[0-9]*$/,
            replacement: "anonymous"
          }
        }
      }

      assert Litmus.validate(data, schema) == {:ok, modified_data}
    end

    test "replaces multiple occurences of a regex within a string" do
      data = %{"username" => "user123"}
      modified_data = %{"username" => "userXXX"}

      schema = %{
        "username" => %Litmus.Type.String{
          replace: %Litmus.Type.String.Replace{
            pattern: ~r/[0-9]/,
            replacement: "X"
          }
        }
      }

      assert Litmus.validate(data, schema) == {:ok, modified_data}
    end

    test "replaces multiple occurences of a string within a string" do
      data = %{"username" => "user212"}
      modified_data = %{"username" => "userX1X"}

      schema = %{
        "username" => %Litmus.Type.String{
          replace: %Litmus.Type.String.Replace{
            pattern: "2",
            replacement: "X"
          }
        }
      }

      assert Litmus.validate(data, schema) == {:ok, modified_data}
    end

    test "replaces a single occurences of a patten when global is false" do
      data = %{"username" => "user123"}
      modified_data = %{"username" => "userX23"}

      schema = %{
        "username" => %Litmus.Type.String{
          replace: %Litmus.Type.String.Replace{
            pattern: ~r/[0-9]/,
            replacement: "X",
            global: false
          }
        }
      }

      assert Litmus.validate(data, schema) == {:ok, modified_data}
    end
  end

  describe "convert to string" do
    test "returns :ok with new parameters having values converted to string when field is boolean or number" do
      data = %{"id" => 1, "new_user" => true}
      modified_data = %{"id" => "1", "new_user" => "true"}

      schema = %{
        "id" => %Litmus.Type.String{},
        "new_user" => %Litmus.Type.String{},
        "description" => %Litmus.Type.String{}
      }

      assert Litmus.validate(data, schema) == {:ok, modified_data}
    end

    test "does not convert nil to a string" do
      data = %{"id" => nil}

      schema = %{
        "id" => %Litmus.Type.String{}
      }

      assert Litmus.validate(data, schema) == {:ok, data}
    end

    test "returns :error when field is neither string nor boolean nor number" do
      data = %{"id" => ["1"]}

      schema = %{
        "id" => %Litmus.Type.String{}
      }

      assert Litmus.validate(data, schema) == {:error, "id must be a string"}
    end
  end
end
