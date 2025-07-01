# Subscript Code Challenge

**Built with ruby 3.4.2**

## How to Use

### With your own ruby

```shell
# Run the application
ruby main.rb input/*

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
