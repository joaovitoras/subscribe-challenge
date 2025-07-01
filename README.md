# Subscribe Challenge

**Built with Ruby 3.4.2**

## How to Use

`ruby main.rb test-1.txt test-2.txt`

If you want to validate output, create a file with the same name in the `outputs` folder with the content of the expected output. Example:
```
| inputs
|   test-1.txt
|   test-2.txt
| outputs
|   test-1.txt
|   test-2.txt
```

### With your own ruby

```shell
# Run the application
ruby main.rb inputs/*

# Run tests
bundle install
bundle exec rspec
```

### Docker
```shell
# Build the Docker image and run the application
docker build -t tax-calculator .
docker run --rm -v $(PWD)/.:/home/challenge/app tax-calculator ruby main.rb inputs/*.txt

# Run tests
docker run --rm -v $(PWD)/.:/home/challenge/app tax-calculator bundle exec rspec
```
