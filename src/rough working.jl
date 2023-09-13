text = query_postgres("raw", "back", condition="where date='2023-09-01'")

articles_to_word_network(text, ("on", "is", "to"), 2, [1.0 0.0; 0.0 1.0; 0.0 1.0])

