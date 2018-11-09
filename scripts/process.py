import av
import numpy as np
import matplotlib
import matplotlib.pyplot as plt
import itertools
import imageio

matplotlib.use("TkAgg")

inputd = dict(snakemake.input)
outputd = dict(snakemake.output)

v = av.open(inputd['movie'])

packets_decode = [p.decode() for p in v.demux()]
packets_decode = [l for l in packets_decode if len(l)>0]

frames = [l[0] for l in packets_decode]

images = [f.to_image() for f in frames]

images_converted = [i.convert('L') for i in images]

nframes = len(images_converted)

arrays = [np.asarray(i) for i in images_converted]

frame_shape = arrays[0].shape

vid = np.concatenate(arrays).reshape([nframes,frame_shape[0],frame_shape[1]])

med = np.median(vid,axis=0)

vid3 = vid.copy()[:nframes-1,]

for i in range(nframes-1):
    diff1=abs(vid[i,]-med)
    diff2=abs(vid[i+1,]-med)
    vid3[i,] = abs(diff1-diff2)

imageio.mimwrite(outputd['movie'], vid3, fps = 30)

means = np.mean(np.mean(vid3,axis=2),axis=1)

tvec=(1.0/30.)*np.arange(0,len(means))

with open(outputd['diffs'],'w') as fo:
    for t,d in zip(tvec,means):
        fo.write(str(t) + '\t' + str(d) + '\n')
