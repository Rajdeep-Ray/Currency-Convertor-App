class Country{
  String symbol,code,currency;
  Country({this.code,this.symbol,this.currency});
}

final List<Country> country = [
    Country(code: 'INR', symbol: '\₹', currency: "Indian rupee"),
    Country(code: 'EUR', symbol: '\€', currency: "Euro"),
    Country(code: 'GBP', symbol: '\£', currency: "Pound sterling"),
    Country(code: 'ISK', symbol: 'Íkr', currency: "Icelandic króna"),
    Country(code: 'RON', symbol: 'lei', currency: "Romanian leu"),
    Country(code: 'SEK', symbol: 'kr', currency: "Swedish krona"),
    Country(code: 'HUF', symbol: 'Ft', currency: "Hungarian forint"),
    Country(code: 'IDR', symbol: 'Rp', currency: "Indonesian rupiah"),
    Country(code: 'BRL', symbol: 'R\$', currency: "Brazilian real"),
    Country(code: 'DKK', symbol: 'Kr.',currency: "Danish krone"),
    Country(code: 'CAD', symbol: '\$',currency: "Canadian dollar"),
    Country(code: 'RUB', symbol: '\₽',currency: "Ruble"),
    Country(code: 'CZK', symbol: 'Kč',currency: "Czech koruna"),
    Country(code: 'AUD', symbol: '\$',currency: "Australian dollar"),
    Country(code: 'PHP', symbol: '\₱',currency: "Philippine peso"),
    Country(code: 'HKD', symbol: '\$',currency: "Hong Kong dollar"),
  ];