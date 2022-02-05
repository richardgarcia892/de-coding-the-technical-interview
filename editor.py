

# Read in the file
with open('export_ancillaries.lua', 'r') as file :
  filedata = file.read()

chance_range = range(100)

# Replace the target string
for chance in chance_range:
  filedata = filedata.replace(f', {str(chance)},', f', 100,')

# Write the file out again
with open('export_ancillaries.lua', 'w') as file:
  file.write(filedata)