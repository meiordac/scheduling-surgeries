import glpk

print "starting..."
pr = glpk.glpk("short.mod")
pr.update()
pr.solve()
#print "solution:", pr.solution()
print "solution is also here: x1 =", pr.x1, "x2 =", pr.x2