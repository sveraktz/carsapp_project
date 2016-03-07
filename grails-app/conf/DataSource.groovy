//dataSource {
//    pooled = true
//    jmxExport = true
//    driverClassName = "org.h2.Driver"
//    username = "sa"
//    password = ""
//}
dataSource {
    pooled = true
    dialect = "org.hibernate.dialect.MySQL5InnoDBDialect"
    driverClassName = 'com.mysql.jdbc.Driver'
    logSql = true
}
hibernate {
    cache.use_second_level_cache = true
    cache.use_query_cache = false
    cache.region.factory_class = 'net.sf.ehcache.hibernate.EhCacheRegionFactory' // Hibernate 3
//    cache.region.factory_class = 'org.hibernate.cache.ehcache.EhCacheRegionFactory' // Hibernate 4
    singleSession = true // configure OSIV singleSession mode
    format_sql = true
    use_sql_comments = true
}

// environment specific settings
environments {
    development {
        dataSource {
            url = "jdbc:mysql://localhost/develop_schema?useUnicode=yes&characterEncoding=UTF-8"
            dbCreate = 'update'
            username = 'root'
            password = 'admin'
        }
//        dataSource {
//            dbCreate = "create-drop" // one of 'create', 'create-drop', 'update', 'validate', ''
//            url = "jdbc:h2:mem:devDb;MVCC=TRUE;LOCK_TIMEOUT=10000;DB_CLOSE_ON_EXIT=FALSE"
//        }
    }
    test {
        dataSource {
            url = "jdbc:mysql://localhost/test_schema?useUnicode=yes&characterEncoding=UTF-8"
            dbCreate = 'create-drop'
            username = 'root'
            password = 'admin'
        }
//        dataSource {
//            dbCreate = "update"
//            url = "jdbc:h2:mem:testDb;MVCC=TRUE;LOCK_TIMEOUT=10000;DB_CLOSE_ON_EXIT=FALSE"
//        }
    }
    production {
        dataSource {
            url = "jdbc:mysql://localhost/autos_schema?useUnicode=yes&characterEncoding=UTF-8"
            dbCreate = 'update'
            username = 'root'
            password = 'admin'
//            dbCreate = "update"
//            url = "jdbc:h2:prodDb;MVCC=TRUE;LOCK_TIMEOUT=10000;DB_CLOSE_ON_EXIT=FALSE"
            properties {
                // See http://grails.org/doc/latest/guide/conf.html#dataSource for documentation
                jmxEnabled = true
                initialSize = 5
                maxActive = 50
                minIdle = 5
                maxIdle = 25
                maxWait = 10000
                maxAge = 10 * 60000
                timeBetweenEvictionRunsMillis = 5000
                minEvictableIdleTimeMillis = 60000
                validationQuery = "SELECT 1"
                validationQueryTimeout = 3
                validationInterval = 15000
                testOnBorrow = true
                testWhileIdle = true
                testOnReturn = false
                jdbcInterceptors = "ConnectionState"
                defaultTransactionIsolation = java.sql.Connection.TRANSACTION_READ_COMMITTED
            }
        }
    }
}
