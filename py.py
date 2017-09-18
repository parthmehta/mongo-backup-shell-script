import subprocess

stdoutdata = subprocess.check_output(["./mongo_backup.sh","skippr", "users"])
print(stdoutdata)


#print(subprocess.STDOUT)

#print ('1', stdoutdata)

#nlines = int(stdoutdata.decode('ascii','igonre').partition(' ')[0])

# Process=subprocess.Popen(['./mongo_backup.sh', 'skippr', 'users'],shell=False, stdout=subprocess.PIPE)
# print(p.communicate())
# print('1',stdout, out,err,Process.returncode)
