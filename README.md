# Subscript Code Challenge

**Built with ruby 3.4.2**

## How to Use

`ruby main.rb test-1.txt test-2.txt`

If you want to validate output create a file with the same name at `outputs` folder and the content of the expected output.

### With your own ruby

```shell
# Run the application
ruby main.rb inputs/*

# Running tests
bundle install
bundle exec rspec
```

### Docker
```shell
# Build the Docker image and run the application
docker build -t tax-calculator .
docker run --rm -v $(PWD)/.:/home/challenge/app tax-calculator ruby main.rb inputs/*.txt

# Running tests
docker run --rm -v $(PWD)/.:/home/challenge/app tax-calculator bundle exec rspec
```
