rule test:
    input:
        movie1="test-movies/extinc1/BL1-1.avi",
        movie2="test-movies/extinc1/BL1-2.avi"
    script:
        "scripts/test.py"
