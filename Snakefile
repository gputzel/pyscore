import os

configfile: "config.json"

rule input_movie_list:
    output:
        "output/input_movies.txt"
    shell:
        'find ' + config['split-movies-path'] + ' -name "*.avi" > {output}'

def input_movies():
    movie_files=[]
    for dirpath,subdirs,files in os.walk(config['split-movies-path']):
        for x in files:
            if x.endswith('.avi'):
                movie_files.append(os.path.join(dirpath,x))
    return movie_files

def process_video_input(wildcards):
    middle = wildcards.middle
    d = {
            'movie':config['split-movies-path'] + '/' + middle + ".avi",
        }
    return d

rule process_video:
    input:
        unpack(process_video_input)
    output:
        movie="output/{middle}.mp4",
        diffs="output/{middle}.tsv"
    conda:
        "envs/image.yml"
    script:
        "scripts/process.py"

rule plot:
    input:
        tsv="output/{middle}.tsv"
    output:
        pdf="output/{middle}.pdf"
    script:
        "scripts/plot.R"

rule process_all:
    input:
        [f.replace(config['split-movies-path'],'output').replace('.avi','.pdf') for f in input_movies()]

rule test:
    input:
        movie="test/input/{name}.avi",
    output:
        movie="test/output/{name}.mp4",
        diffs="test/output/{name}.tsv"
    conda:
        "envs/image.yml"
    script:
        "scripts/test.py"

rule plot_test:
    input:
        tsv="test/output/{name}.tsv"
    output:
        pdf="test/output/{name}.pdf"
    script:
        "scripts/plot.R"

def test_all_input():
    names, = glob_wildcards("test/input/{name}.avi")
    return ["test/output/" + name + ".pdf" for name in names]

rule test_all:
    input: test_all_input()
