# Subscribe Challenge

**Built with Ruby 3.4.2**

## Challenge validation
To validate challenge inputs just run:
```shell
ruby main.rb inputs/*
```

## How to Use

If you want to validate output, create a file with the same name in the `outputs` folder with the content of the expected output. Example:
```
| inputs
|-- test-1.txt
|-- test-2.txt
| outputs
|-- test-1.txt
|-- test-2.txt
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

# What I would do different If I had more time

I spent 4 hours resolving the challenge to finish what is requested.
With more time, I know that I could improve a lot of things focusing on:
* Responsibility segregation
* Maintainability
* Future-proofing
* Documentation
* Different user interactions approaches
* Architecture

So I have decided to explain this ideas below.

## Architecture Layers

### 1. Domain Layer (`lib/domain/`)
Adding the core business logic and rules:
- **Entities**: Core business objects (`Product`, `ShoppingBasket`)
- **Value Objects**: Objects representing concepts (`Money`)
- **Services**: Business logic services (`TaxCalculator`, `ReceiptGenerator`, `ProductCategoryClassifier`)

### 2. Infrastructure Layer (`lib/infrastructure/`)
Handling external concerns:
- **ProductParser**: Parses text input into domain product
- **FileHandler**: File system operations

### 3. Application Layer (`lib/application/`)
Orchestrates user interaction with other layers:
- **ProcessReceipt**: Main business flow for processing receipts interacting with other layers

## Design Patterns I would use

### Strategy Pattern
For tax calculation:
* Allow easy addition of new tax rules
* I used it for my initial implementation, but I would extract this from the Product entity because Tax can live well out of Product and can have more variables like:
	* A tax based on total price of sale for specific products
	* A tax based on payment type
	* A tax based on payment currency
	* And it does not belong specifically to the product, but has it as a variable

### Value Object Pattern
- `Money`:
	- Handles monetary calculations, precision, rounding
	- It can be useful for future features as the app grows

### Service Object Pattern
- `TaxCalculator`: Coordinates tax strategies
- `ReceiptGenerator`: Formats receipt output
- `ProductCategoryClassifier`: Categorizes products based on some rules

### Use Case Pattern
- `ProcessReceipt`: Encapsulates the complete receipt processing workflow with chains of responsability

## Benefits
1. **Single Responsibility**: Each class has one clear purpose
2. **Open/Closed Principle**: Easy to add new tax rules without modifying existing code and without depending only on the product
3. **Testability**: Easy to unit test individual components
4. **Maintainability**: Clear separation makes changes safer and easier

## File Structure
```
lib/
├── domain/
│   ├── entities/
│   │   ├── product.rb
│   │   └── shopping_basket.rb
│   ├── value_objects/
│   │   ├── money.rb
│   └── services/
│       ├── tax_calculator.rb
│       ├── receipt_generator.rb
│       ├── product_category_classifier.rb
│       └── tax_strategies/
│           ├── base_tax_strategy.rb
│           ├── basic_sales_tax.rb
│           └── import_duty_tax.rb
├── infrastructure/
│   ├── product_parser.rb
│   └── file_handler.rb
└── application/
    └── process_receipt.rb
```
