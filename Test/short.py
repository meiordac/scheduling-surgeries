import subprocess
capture = subprocess.check_output(["glpsol", "--math", "short.mod", "--output", "noisy.out"])
print ("complete")