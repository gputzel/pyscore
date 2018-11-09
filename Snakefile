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

rule plot:
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
