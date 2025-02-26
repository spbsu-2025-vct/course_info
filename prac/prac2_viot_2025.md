
# Начало работы с БД 

# Мем дня
![Мем дня](https://github.com/user-attachments/assets/2a8041b0-42e3-41cb-a79c-191be30c757f)

### **Запуск контейнеров с помощью `docker-compose.yml`**

1. **Создайте файл `docker-compose.yml`**:
    
    - В файле опишите сервисы (контейнеры), которые нужно запустить. Пример:

```yml,name='docker-compose.yml'
version: '3'

services:
  postgres:
    image: postgres:14
    ports: ["5432:5432"]
    environment:
      POSTGRES_PASSWORD: postgres

  mariadb:
    image: mariadb:10.6
    ports: ["3306:3306"]
    environment:
      MYSQL_ROOT_PASSWORD: root

  neo4j:
    image: neo4j:4.4
    ports: ["7474:7474", "7687:7687"]
    environment:
      NEO4J_AUTH: neo4j/password

  mongodb:
    image: mongo:6.0
    ports: ["27017:27017"]

  clickhouse:
    image: clickhouse/clickhouse-server:23.3
    ports: ["8123:8123", "9000:9000"]
```


Этот `docker-compose.yml` файл описывает развертывание пяти различных баз данных: PostgreSQL, MariaDB, Neo4j, MongoDB и ClickHouse.

 **1. Общая структура**
```yaml
version: '3'
```
- **`version: '3'`**: Указывает версию формата файла `docker-compose`. Версия 3 поддерживает большинство современных функций Docker.

**2. Сервисы (services)**
Каждый сервис представляет собой отдельный контейнер, который будет запущен.

 **2.1. PostgreSQL**
```yaml
postgres:
  image: postgres:14
  ports: ["5432:5432"]
  environment:
    POSTGRES_PASSWORD: postgres
```
- **`postgres:`**: Имя сервиса. Используется для обращения к контейнеру внутри Docker-сети.
- **`image: postgres:14`**: Используемый образ Docker. В данном случае это PostgreSQL версии 14.
- **`ports: ["5432:5432"]`**: Проброс портов. Левый порт (`5432`) — порт на хосте, правый порт (`5432`) — порт внутри контейнера.
- **`environment:`**: Переменные окружения.
  - **`POSTGRES_PASSWORD: postgres`**: Пароль для пользователя `postgres` (суперпользователя).

 **2.2. MariaDB**
```yaml
mariadb:
  image: mariadb:10.6
  ports: ["3306:3306"]
  environment:
    MYSQL_ROOT_PASSWORD: root
```
- **`mariadb:`**: Имя сервиса.
- **`image: mariadb:10.6`**: Образ MariaDB версии 10.6.
- **`ports: ["3306:3306"]`**: Проброс порта 3306 (стандартный порт для MySQL/MariaDB).
- **`environment:`**: Переменные окружения.
  - **`MYSQL_ROOT_PASSWORD: root`**: Пароль для пользователя `root`.

 **2.3. Neo4j**
```yaml
neo4j:
  image: neo4j:4.4
  ports: ["7474:7474", "7687:7687"]
  environment:
    NEO4J_AUTH: neo4j/password
```
- **`neo4j:`**: Имя сервиса.
- **`image: neo4j:4.4`**: Образ Neo4j версии 4.4.
- **`ports: ["7474:7474", "7687:7687"]`**: Проброс портов:
  - `7474` — порт для веб-интерфейса Neo4j Browser.
  - `7687` — порт для Bolt-протокола (используется для подключения клиентов).
- **`environment:`**: Переменные окружения.
  - **`NEO4J_AUTH: neo4j/password`**: Логин и пароль для доступа к Neo4j. В данном случае логин — `neo4j`, пароль — `password`.

 **2.4. MongoDB**
```yaml
mongodb:
  image: mongo:6.0
  ports: ["27017:27017"]
```
- **`mongodb:`**: Имя сервиса.
- **`image: mongo:6.0`**: Образ MongoDB версии 6.0.
- **`ports: ["27017:27017"]`**: Проброс порта 27017 (стандартный порт для MongoDB).

 **2.5. ClickHouse**
```yaml
clickhouse:
  image: clickhouse/clickhouse-server:23.3
  ports: ["8123:8123", "9000:9000"]
```
- **`clickhouse:`**: Имя сервиса.
- **`image: clickhouse/clickhouse-server:23.3`**: Образ ClickHouse версии 23.3.
- **`ports: ["8123:8123", "9000:9000"]`**: Проброс портов:
  - `8123` — порт для HTTP-запросов.
  - `9000` — порт для нативного протокола ClickHouse.

---

**Доступ к базам данных**:
   - **PostgreSQL**: `localhost:5432` (логин: `postgres`, пароль: `postgres`).
   - **MariaDB**: `localhost:3306` (логин: `root`, пароль: `root`).
   - **Neo4j**: Веб-интерфейс доступен по `http://localhost:7474` (логин: `neo4j`, пароль: `password`).
   - **MongoDB**: `localhost:27017`.
   - **ClickHouse**: HTTP-интерфейс доступен по `http://localhost:8123`.

**Дополнительные возможности**
- **Тома (volumes)**:
  Вы можете добавить тома для сохранения данных между перезапусками контейнеров. Например:
  ```yaml
  volumes:
    - postgres_data:/var/lib/postgresql/data
    - mariadb_data:/var/lib/mysql
    - neo4j_data:/data
    - mongodb_data:/data/db
    - clickhouse_data:/var/lib/clickhouse
  ```

- **Сети (networks)**:
  Вы можете создать отдельную сеть для контейнеров, чтобы они могли взаимодействовать между собой:
  ```yaml
  networks:
    my_network:
      driver: bridge
  ```

- **Переменные окружения из файла**:
  Вместо указания переменных окружения в `docker-compose.yml`, можно вынести их в отдельный файл (например, `.env`).
  

2. **Запустите контейнеры**:

	- Перейдите в папку с `docker-compose.yml`.
	- Выполните команду:
	    `docker-compose up -d`
		Флаг `-d` запускает контейнеры в фоновом режиме (detached mode).
		
3. **Проверка работы**:
    
    - Убедитесь, что контейнеры запущены:        
	    `docker-compose ps`
### **Остановка контейнеров** (после работы с БД)

1. **Остановка без удаления**:
    
    - Выполните команду:
        `docker-compose stop`
        
    - Контейнеры остановятся, но их данные и конфигурация сохранятся.
        
2. **Остановка с удалением**:
    
    - Чтобы остановить и удалить контейнеры, выполните:
        `docker-compose down`
    - Добавьте флаг `-v`, чтобы удалить тома (volumes):
        `docker-compose down -v`

### **Ссылки на документацию Docker**

- **Docker Compose Overview**: [https://docs.docker.com/compose/](https://docs.docker.com/compose/)
- **docker-compose up**: [https://docs.docker.com/compose/reference/up/](https://docs.docker.com/compose/reference/up/)
- **docker-compose down**: [https://docs.docker.com/compose/reference/down/](https://docs.docker.com/compose/reference/down/)


### **Типы БД**

---

### **1. Реляционные (SQL) БД**
- **Описание**: Данные хранятся в таблицах с строгой схемой. Используют язык SQL для запросов.
- **Особенности**:
  - Поддержка ACID (Atomicity, Consistency, Isolation, Durability).
  - Подходят для структурированных данных.
- **Примеры**:
  1. **PostgreSQL** — мощная, расширяемая SQL-БД.
  2. **MySQL** — популярная БД для веб-приложений.
  3. **SQLite** — легковесная встраиваемая БД.

---

### **2. NoSQL БД**
- **Описание**: Не используют SQL и реляционную модель. Подходят для неструктурированных или полуструктурированных данных.
- **Типы NoSQL**:
  - **Документоориентированные**:
    - Хранят данные в формате JSON/BSON.
    - Примеры: **MongoDB**, **CouchDB**.
  - **Ключ-значение**:
    - Хранят данные как пары ключ-значение.
    - Примеры: **Redis**, **Amazon DynamoDB**.
  - **Колоночные**:
    - Хранят данные по столбцам, а не строкам.
    - Примеры: **Cassandra**, **HBase**.
  - **Поисковые**:
    - Оптимизированы для полнотекстового поиска.
    - Примеры: **Elasticsearch**, **Apache Solr**.

---

### **3. Графовые БД**
- **Описание**: Хранят данные в виде графов (узлы, ребра и свойства). Подходят для работы со сложными связями.
- **Особенности**:
  - Эффективны для запросов, связанных с отношениями (например, социальные сети, рекомендательные системы).
- **Примеры**:
  1. **Neo4j** — самая популярная графовая БД.
  2. **Amazon Neptune** — управляемая графовая БД от AWS.
  3. **ArangoDB** — мультимодельная БД с поддержкой графов.
  4. **Nebula**

---

### **4. Временные ряды (Time-Series) БД**
- **Описание**: Оптимизированы для хранения и анализа данных, зависящих от времени (метрики, логи, IoT).
- **Особенности**:
  - Эффективны для запросов по временным интервалам.
- **Примеры**:
  1. **InfluxDB** — популярная БД для временных рядов.
  2. **TimescaleDB** — расширение PostgreSQL для временных рядов.
  3. **Prometheus** — БД для мониторинга и метрик.

---

### **5. Колоночные БД**
- **Описание**: Хранят данные по столбцам, а не строкам. Подходят для аналитики и больших данных.
- **Особенности**:
  - Высокая производительность для агрегаций и аналитических запросов.
- **Примеры**:
  1. **ClickHouse** — высокопроизводительная аналитическая БД.
  2. **Amazon Redshift** — облачное хранилище данных.
  3. **Apache Parquet** — формат хранения колоночных данных.

---

### **6. In-Memory БД**
- **Описание**: Хранят данные в оперативной памяти для максимальной скорости.
- **Особенности**:
  - Подходят для кэширования и высоконагруженных приложений.
- **Примеры**:
  1. **Redis** — БД ключ-значение с поддержкой сложных структур данных.
  2. **Memcached** — высокопроизводительная БД для кэширования.

---

### **7. Объектно-ориентированные БД**
- **Описание**: Хранят данные в виде объектов, как в ООП.
- **Особенности**:
  - Подходят для сложных структур данных.
- **Примеры**:
  1. **db4o** — объектно-ориентированная БД.
  2. **ObjectDB** — БД для Java.

---

### **8. Мультимодельные БД**
- **Описание**: Поддерживают несколько моделей данных (например, документы и графы).
- **Особенности**:
  - Универсальность для разных типов данных.
- **Примеры**:
  1. **ArangoDB** — поддерживает документы, графы и ключ-значение.
  2. **Couchbase** — документы и ключ-значение.

---

- **Документация MongoDB**:
    - [https://www.mongodb.com/docs/](https://www.mongodb.com/docs/)
    - Подробное описание NoSQL, документоориентированных БД и их использования.
- **Документация PostgreSQL**:
    - [https://www.postgresql.org/docs/](https://www.postgresql.org/docs/)
    - Описание реляционных БД и их возможностей.
- **Документация Neo4j**:
    - [https://neo4j.com/docs/](https://neo4j.com/docs/)
    - Подробно о графовых БД и их применении.
- **Документация Clickhouse:**
	- https://clickhouse.com/docs/ru
	- Подробно о колоночных БД.

Рассмотрим несколько примеров.
### **1. PostgreSQL / MariaDB (Реляционные БД)**  
**DDL**:  
```sql
-- Клиенты
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE
);

-- Товары
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);

-- Заказы
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(id),
    order_date DATE NOT NULL
);

-- Состав заказа
CREATE TABLE order_items (
    order_id INT REFERENCES orders(id),
    product_id INT REFERENCES products(id),
    quantity INT NOT NULL,
    PRIMARY KEY (order_id, product_id)
);
```

**SELECT-запросы**:  
```sql
-- Сумма заказа №1
SELECT 
    o.id AS order_id,
    SUM(p.price * oi.quantity) AS total
FROM orders o
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
WHERE o.id = 1
GROUP BY o.id;

-- Все заказы клиента "Иван Иванов"
SELECT o.* 
FROM orders o
JOIN customers c ON o.customer_id = c.id
WHERE c.name = 'Иван Иванов';
```

---

### **2. MongoDB (Документная БД)**  
**Структура коллекций**:  
```javascript
// Коллекция "customers"
{
    _id: ObjectId("..."),
    name: "Иван Иванов",
    email: "ivan@example.com"
}

// Коллекция "orders"
{
    _id: ObjectId("..."),
    customer_id: ObjectId("..."),
    order_date: ISODate("2023-10-01"),
    items: [
        { product_id: ObjectId("..."), quantity: 2, price: 100 },
        { product_id: ObjectId("..."), quantity: 1, price: 50 }
    ]
}
```

**SELECT-запросы**:  
```javascript
// Сумма заказа по ID
db.orders.aggregate([
    { $match: { _id: ObjectId("...") } },
    { $unwind: "$items" },
    { 
        $group: {
            _id: "$_id",
            total: { $sum: { $multiply: ["$items.quantity", "$items.price"] } }
        }
    }
]);

// Все заказы клиента по email
db.orders.find({
    customer_id: db.customers.findOne({ email: "ivan@example.com" })._id
});
```

---

### **3. Neo4j (Графовая БД)**  
**Создание узлов и связей**:  
```cypher
// Клиент
CREATE (c:Customer { id: 1, name: "Иван Иванов", email: "ivan@example.com" });

// Товары
CREATE (p1:Product { id: 101, name: "Книга", price: 100 });
CREATE (p2:Product { id: 102, name: "Наушники", price: 50 });

// Заказ
CREATE (o:Order { id: 1001, date: "2023-10-01" });

// Связи
MATCH (c:Customer { id: 1 }), (o:Order { id: 1001 })
CREATE (c)-[:PLACED_ORDER]->(o);

MATCH (o:Order { id: 1001 }), (p:Product { id: 101 })
CREATE (o)-[:CONTAINS { quantity: 2 }]->(p);

MATCH (o:Order { id: 1001 }), (p:Product { id: 102 })
CREATE (o)-[:CONTAINS { quantity: 1 }]->(p);
```

**SELECT-запросы**:  
```cypher
-- Сумма заказа №1001
MATCH (o:Order { id: 1001 })-[c:CONTAINS]->(p:Product)
RETURN o.id, SUM(c.quantity * p.price) AS total;

-- Все заказы клиента "Иван Иванов"
MATCH (c:Customer { name: "Иван Иванов" })-[:PLACED_ORDER]->(o:Order)
RETURN o;
```

---

### **4. ClickHouse (Колоночная БД)**  
**DDL**:  
```sql
-- Денормализованная таблица заказов
CREATE TABLE orders (
    order_id UInt64,
    customer_id UInt64,
    customer_name String,
    order_date Date,
    product_id UInt64,
    product_name String,
    quantity UInt32,
    price Decimal(10, 2)
) ENGINE = MergeTree()
ORDER BY (order_date, order_id);
```

**SELECT-запросы**:  
```sql
-- Сумма продаж за 2023-10-01
SELECT 
    order_date,
    SUM(quantity * price) AS daily_revenue
FROM orders
WHERE order_date = '2023-10-01'
GROUP BY order_date;

-- Топ-3 товаров по продажам
SELECT 
    product_name,
    SUM(quantity) AS total_quantity
FROM orders
GROUP BY product_name
ORDER BY total_quantity DESC
LIMIT 3;
```

---

### Итого:  
- **PostgreSQL/MariaDB**: Классические таблицы с JOIN.  
- **MongoDB**: Гибкие документы с вложенными массивами.  
- **Neo4j**: Графовые связи для анализа отношений.  
- **ClickHouse**: Денормализованные данные для аналитики.  

Каждая БД решает задачи в рамках своей специализации: реляционные для транзакций, документные для гибкости, графовые для связей, колоночные для аналитики.

## Можно почитать (Спасибо Марку)

1. [Снежинка, Data Vault, Anchor Modeling.](https://habr.com/ru/articles/786822/)
2. [Data Vault](https://habr.com/ru/articles/348188/)
3. [OLAP/OLTP](https://aws.amazon.com/ru/compare/the-difference-between-olap-and-oltp/)
4. [ODS|DDS|ELT|ETL](https://datafinder.ru/products/obzor-osnovnyh-komponentov-stage-ods-dds-datamart-bi-metadata-i-processov-etl-elt-dq)
   

# Для теста
## Наполнение сущностей данными
### **1. PostgreSQL / MariaDB (Реляционные БД)**  

```sql

-- Заполнение customers (10 клиентов)
INSERT INTO customers (name, email) VALUES
('Customer 1', 'customer1@test.com'),
('Customer 2', 'customer2@test.com'),
('Customer 3', 'customer3@test.com'),
('Customer 4', 'customer4@test.com'),
('Customer 5', 'customer5@test.com'),
('Customer 6', 'customer6@test.com'),
('Customer 7', 'customer7@test.com'),
('Customer 8', 'customer8@test.com'),
('Customer 9', 'customer9@test.com'),
('Customer 10', 'customer10@test.com');

-- Заполнение products (10 товаров)
INSERT INTO products (name, price) VALUES
('Smartphone', 299.99),
('Laptop', 999.50),
('Wireless Headphones', 149.99),
('Smart Watch', 199.00),
('Tablet', 399.00),
('E-book Reader', 129.95),
('Gaming Mouse', 59.99),
('Bluetooth Speaker', 79.50),
('Power Bank', 39.99),
('USB-C Cable', 12.99);

-- Заполнение orders (10 заказов)
INSERT INTO orders (customer_id, order_date) VALUES
(1, '2023-10-05'),
(2, '2023-10-06'),
(3, '2023-10-07'),
(4, '2023-10-08'),
(5, '2023-10-09'),
(6, '2023-10-10'),
(7, '2023-10-11'),
(8, '2023-10-12'),
(9, '2023-10-13'),
(10, '2023-10-14');

-- Заполнение order_items (20 позиций)
INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 1),   -- Order 1: Smartphone x1
(1, 3, 2),   -- Order 1: Headphones x2
(2, 2, 1),   -- Order 2: Laptop x1
(3, 5, 1),   -- Order 3: Tablet x1
(3, 10, 3),  -- Order 3: USB-C Cable x3
(4, 4, 2),   -- Order 4: Smart Watch x2
(5, 6, 1),   -- Order 5: E-book Reader x1
(6, 7, 1),   -- Order 6: Gaming Mouse x1
(6, 8, 1),   -- Order 6: Speaker x1
(7, 9, 2),   -- Order 7: Power Bank x2
(8, 2, 1),   -- Order 8: Laptop x1
(8, 5, 1),   -- Order 8: Tablet x1
(9, 10, 5),  -- Order 9: USB-C Cable x5
(10, 1, 1),  -- Order 10: Smartphone x1
(10, 3, 1),  -- Order 10: Headphones x1
(10, 4, 1);  -- Order 10: Smart Watch x1

```


## **2. MongoDB (Документная БД)**  

### **Примеры данных для коллекции `customers` (10 документов)**

```javascript
// Коллекция "customers"
db.customers.insertMany([
    { _id: ObjectId("653f1a8e1c9d440000000001"), name: "Иван Иванов", email: "ivan@example.com" },
    { _id: ObjectId("653f1a8e1c9d440000000002"), name: "Мария Петрова", email: "maria@example.com" },
    { _id: ObjectId("653f1a8e1c9d440000000003"), name: "Алексей Смирнов", email: "alex@example.com" },
    { _id: ObjectId("653f1a8e1c9d440000000004"), name: "Ольга Сидорова", email: "olga@example.com" },
    { _id: ObjectId("653f1a8e1c9d440000000005"), name: "Дмитрий Кузнецов", email: "dmitry@example.com" },
    { _id: ObjectId("653f1a8e1c9d440000000006"), name: "Анна Воробьева", email: "anna@example.com" },
    { _id: ObjectId("653f1a8e1c9d440000000007"), name: "Сергей Павлов", email: "sergey@example.com" },
    { _id: ObjectId("653f1a8e1c9d440000000008"), name: "Екатерина Новикова", email: "ekaterina@example.com" },
    { _id: ObjectId("653f1a8e1c9d440000000009"), name: "Павел Федоров", email: "pavel@example.com" },
    { _id: ObjectId("653f1a8e1c9d440000000010"), name: "Наталья Козлова", email: "natalia@example.com" }
]);
```

---

### **Примеры данных для коллекции `orders` (10 документов)**

```javascript
// Коллекция "orders"
db.orders.insertMany([
    {
        _id: ObjectId("653f1a8e1c9d440000000011"),
        customer_id: ObjectId("653f1a8e1c9d440000000001"),
        order_date: ISODate("2023-10-01"),
        items: [
            { product_id: ObjectId("653f1a8e1c9d440000000101"), quantity: 2, price: 100 },
            { product_id: ObjectId("653f1a8e1c9d440000000102"), quantity: 1, price: 50 }
        ]
    },
    {
        _id: ObjectId("653f1a8e1c9d440000000012"),
        customer_id: ObjectId("653f1a8e1c9d440000000002"),
        order_date: ISODate("2023-10-02"),
        items: [
            { product_id: ObjectId("653f1a8e1c9d440000000103"), quantity: 1, price: 200 },
            { product_id: ObjectId("653f1a8e1c9d440000000104"), quantity: 3, price: 75 }
        ]
    },
    {
        _id: ObjectId("653f1a8e1c9d440000000013"),
        customer_id: ObjectId("653f1a8e1c9d440000000003"),
        order_date: ISODate("2023-10-03"),
        items: [
            { product_id: ObjectId("653f1a8e1c9d440000000105"), quantity: 1, price: 150 },
            { product_id: ObjectId("653f1a8e1c9d440000000106"), quantity: 2, price: 30 }
        ]
    },
    {
        _id: ObjectId("653f1a8e1c9d440000000014"),
        customer_id: ObjectId("653f1a8e1c9d440000000004"),
        order_date: ISODate("2023-10-04"),
        items: [
            { product_id: ObjectId("653f1a8e1c9d440000000107"), quantity: 1, price: 99 },
            { product_id: ObjectId("653f1a8e1c9d440000000108"), quantity: 1, price: 120 }
        ]
    },
    {
        _id: ObjectId("653f1a8e1c9d440000000015"),
        customer_id: ObjectId("653f1a8e1c9d440000000005"),
        order_date: ISODate("2023-10-05"),
        items: [
            { product_id: ObjectId("653f1a8e1c9d440000000109"), quantity: 2, price: 80 },
            { product_id: ObjectId("653f1a8e1c9d440000000110"), quantity: 1, price: 45 }
        ]
    },
    {
        _id: ObjectId("653f1a8e1c9d440000000016"),
        customer_id: ObjectId("653f1a8e1c9d440000000006"),
        order_date: ISODate("2023-10-06"),
        items: [
            { product_id: ObjectId("653f1a8e1c9d440000000111"), quantity: 1, price: 300 },
            { product_id: ObjectId("653f1a8e1c9d440000000112"), quantity: 2, price: 25 }
        ]
    },
    {
        _id: ObjectId("653f1a8e1c9d440000000017"),
        customer_id: ObjectId("653f1a8e1c9d440000000007"),
        order_date: ISODate("2023-10-07"),
        items: [
            { product_id: ObjectId("653f1a8e1c9d440000000113"), quantity: 1, price: 199 },
            { product_id: ObjectId("653f1a8e1c9d440000000114"), quantity: 1, price: 50 }
        ]
    },
    {
        _id: ObjectId("653f1a8e1c9d440000000018"),
        customer_id: ObjectId("653f1a8e1c9d440000000008"),
        order_date: ISODate("2023-10-08"),
        items: [
            { product_id: ObjectId("653f1a8e1c9d440000000115"), quantity: 3, price: 60 },
            { product_id: ObjectId("653f1a8e1c9d440000000116"), quantity: 1, price: 90 }
        ]
    },
    {
        _id: ObjectId("653f1a8e1c9d440000000019"),
        customer_id: ObjectId("653f1a8e1c9d440000000009"),
        order_date: ISODate("2023-10-09"),
        items: [
            { product_id: ObjectId("653f1a8e1c9d440000000117"), quantity: 1, price: 120 },
            { product_id: ObjectId("653f1a8e1c9d440000000118"), quantity: 2, price: 40 }
        ]
    },
    {
        _id: ObjectId("653f1a8e1c9d440000000020"),
        customer_id: ObjectId("653f1a8e1c9d440000000010"),
        order_date: ISODate("2023-10-10"),
        items: [
            { product_id: ObjectId("653f1a8e1c9d440000000119"), quantity: 1, price: 250 },
            { product_id: ObjectId("653f1a8e1c9d440000000120"), quantity: 1, price: 70 }
        ]
    }
]);
```


---


## **4. ClickHouse (Колоночная БД)**  

```sql

INSERT INTO orders VALUES
(1, 101, 'Иван Иванов', '2023-01-05', 1001, 'Смартфон', 1, 299.99),
(2, 102, 'Мария Петрова', '2023-01-07', 1002, 'Ноутбук', 1, 999.50),
(3, 103, 'Алексей Смирнов', '2023-01-12', 1003, 'Наушники', 2, 149.99),
(4, 104, 'Ольга Сидорова', '2023-02-02', 1004, 'Умные часы', 1, 199.00),
(5, 105, 'Дмитрий Кузнецов', '2023-02-14', 1005, 'Планшет', 1, 399.00),
(6, 106, 'Анна Воробьева', '2023-03-08', 1006, 'Электронная книга', 1, 129.95),
(7, 107, 'Сергей Павлов', '2023-03-15', 1007, 'Игровая мышь', 1, 59.99),
(8, 108, 'Екатерина Новикова', '2023-04-01', 1008, 'Колонка', 1, 79.50),
(9, 109, 'Павел Федоров', '2023-04-22', 1009, 'Пауэрбанк', 2, 39.99),
(10, 110, 'Наталья Козлова', '2023-05-11', 1010, 'Кабель USB-C', 3, 12.99),
(11, 101, 'Иван Иванов', '2023-05-20', 1001, 'Смартфон', 1, 299.99),
(12, 102, 'Мария Петрова', '2023-06-03', 1002, 'Ноутбук', 1, 999.50),
(13, 103, 'Алексей Смирнов', '2023-06-15', 1003, 'Наушники', 1, 149.99),
(14, 104, 'Ольга Сидорова', '2023-07-01', 1004, 'Умные часы', 2, 199.00),
(15, 105, 'Дмитрий Кузнецов', '2023-07-10', 1005, 'Планшет', 1, 399.00),
(16, 106, 'Анна Воробьева', '2023-08-05', 1006, 'Электронная книга', 1, 129.95),
(17, 107, 'Сергей Павлов', '2023-08-20', 1007, 'Игровая мышь', 2, 59.99),
(18, 108, 'Екатерина Новикова', '2023-09-02', 1008, 'Колонка', 1, 79.50),
(19, 109, 'Павел Федоров', '2023-09-15', 1009, 'Пауэрбанк', 1, 39.99),
(20, 110, 'Наталья Козлова', '2023-10-01', 1010, 'Кабель USB-C', 5, 12.99),
(21, 101, 'Иван Иванов', '2023-10-10', 1001, 'Смартфон', 1, 299.99),
(22, 102, 'Мария Петрова', '2023-10-15', 1002, 'Ноутбук', 1, 999.50),
(23, 103, 'Алексей Смирнов', '2023-10-20', 1003, 'Наушники', 1, 149.99),
(24, 104, 'Ольга Сидорова', '2023-11-01', 1004, 'Умные часы', 1, 199.00),
(25, 105, 'Дмитрий Кузнецов', '2023-11-05', 1005, 'Планшет', 1, 399.00),
(26, 106, 'Анна Воробьева', '2023-11-10', 1006, 'Электронная книга', 1, 129.95),
(27, 107, 'Сергей Павлов', '2023-11-15', 1007, 'Игровая мышь', 1, 59.99),
(28, 108, 'Екатерина Новикова', '2023-11-20', 1008, 'Колонка', 1, 79.50),
(29, 109, 'Павел Федоров', '2023-12-01', 1009, 'Пауэрбанк', 2, 39.99),
(30, 110, 'Наталья Козлова', '2023-12-05', 1010, 'Кабель USB-C', 3, 12.99),
(31, 101, 'Иван Иванов', '2023-01-10', 1001, 'Смартфон', 1, 299.99),
(32, 102, 'Мария Петрова', '2023-01-15', 1002, 'Ноутбук', 1, 999.50),
(33, 103, 'Алексей Смирнов', '2023-01-20', 1003, 'Наушники', 1, 149.99),
(34, 104, 'Ольга Сидорова', '2023-02-05', 1004, 'Умные часы', 1, 199.00),
(35, 105, 'Дмитрий Кузнецов', '2023-02-10', 1005, 'Планшет', 1, 399.00),
(36, 106, 'Анна Воробьева', '2023-02-15', 1006, 'Электронная книга', 1, 129.95),
(37, 107, 'Сергей Павлов', '2023-02-20', 1007, 'Игровая мышь', 1, 59.99),
(38, 108, 'Екатерина Новикова', '2023-03-01', 1008, 'Колонка', 1, 79.50),
(39, 109, 'Павел Федоров', '2023-03-05', 1009, 'Пауэрбанк', 1, 39.99),
(40, 110, 'Наталья Козлова', '2023-03-10', 1010, 'Кабель USB-C', 2, 12.99),
(41, 101, 'Иван Иванов', '2023-03-15', 1001, 'Смартфон', 1, 299.99),
(42, 102, 'Мария Петрова', '2023-03-20', 1002, 'Ноутбук', 1, 999.50),
(43, 103, 'Алексей Смирнов', '2023-04-01', 1003, 'Наушники', 1, 149.99),
(44, 104, 'Ольга Сидорова', '2023-04-05', 1004, 'Умные часы', 1, 199.00),
(45, 105, 'Дмитрий Кузнецов', '2023-04-10', 1005, 'Планшет', 1, 399.00),
(46, 106, 'Анна Воробьева', '2023-04-15', 1006, 'Электронная книга', 1, 129.95),
(47, 107, 'Сергей Павлов', '2023-04-20', 1007, 'Игровая мышь', 1, 59.99),
(48, 108, 'Екатерина Новикова', '2023-05-01', 1008, 'Колонка', 1, 79.50),
(49, 109, 'Павел Федоров', '2023-05-05', 1009, 'Пауэрбанк', 1, 39.99),
(50, 110, 'Наталья Козлова', '2023-05-10', 1010, 'Кабель USB-C', 2, 12.99),
(51, 101, 'Иван Иванов', '2023-05-15', 1001, 'Смартфон', 1, 299.99)
```

