inputd = dict(snakemake.input)
outputd = dict(snakemake.output)
config = dict(snakemake.config)

with open(inputd['diffs'],'r') as fi:
    freezing = []
    for l in fi.readlines():
        t,signal = l.rstrip('\n').split()
        t = float(t)
        signal = float(signal)
        if t > 1.0:
            if signal > config['freeze-signal-threshold']:
                freezing.append(0.0)
            else:
                freezing.append(1.0)

s = sum(freezing)
n = len(freezing)
freeze_rate = s/float(n)
with open(outputd['freeze'],'w') as fo:
    fo.write(str(inputd['diffs']) + '\t' + str(freeze_rate) + '\n')
