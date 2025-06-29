def change_into_integer(string)
  string.delete("IDR").delete(".").to_i
end
