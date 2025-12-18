# 📊 Entity Relationship Diagram

## Database Schema Overview

```mermaid
erDiagram
    USERS ||--o{ ORDERS : places
    USERS ||--o{ CART_ITEMS : adds
    CATEGORIES ||--o{ PRODUCTS : categorizes
    PRODUCTS ||--o{ ORDER_ITEMS : "appears in"
    PRODUCTS ||--o{ CART_ITEMS : "added to"
    ORDERS ||--o{ ORDER_ITEMS : contains
    
    USERS {
        int user_id PK
        string username UK
        string email UK
        string password_hash
        string full_name
        timestamp created_at
        boolean is_active
        string phone
        text address
    }
    
    CATEGORIES {
        int category_id PK
        string category_name UK
        text description
        int parent_category_id FK
        timestamp created_at
    }
    
    PRODUCTS {
        int product_id PK
        string product_name
        text description
        decimal price
        decimal cost_price
        int category_id FK
        string sku UK
        int stock_quantity
        int reorder_level
        boolean is_active
        timestamp created_at
        string brand
    }
    
    ORDERS {
        int order_id PK
        int user_id FK
        timestamp order_date
        string status
        decimal total_amount
        string payment_method
        string payment_status
        string shipping_method
        string tracking_number
    }
    
    ORDER_ITEMS {
        int order_item_id PK
        int order_id FK
        int product_id FK
        int quantity
        decimal unit_price
        decimal subtotal
        decimal discount_amount
    }
    
    CART_ITEMS {
        int cart_item_id PK
        int user_id FK
        int product_id FK
        int quantity
        timestamp added_at
    }