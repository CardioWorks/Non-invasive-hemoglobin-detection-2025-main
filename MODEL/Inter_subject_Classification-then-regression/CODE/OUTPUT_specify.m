function  [result] = OUTPUT_specify(result)
result = round(result);
result = max(min(result, 2), 0);
end