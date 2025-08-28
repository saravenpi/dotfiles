---
allowed-tools: Glob, Read, Edit, MultiEdit, Grep, Bash, Write
description: Profile performance bottlenecks and apply comprehensive optimizations across the codebase.
---

## Performance Optimization Command

Analyzes application performance, identifies bottlenecks, and applies targeted optimizations to improve speed, memory usage, and resource efficiency.

### Process:

1. **Performance Profiling**:
   - **Runtime Analysis**: Profile CPU usage, memory consumption, and execution time
   - **Database Queries**: Identify slow queries and N+1 problems
   - **Network Requests**: Analyze API calls and external dependencies
   - **Bundle Analysis**: Check JavaScript bundle sizes and dependencies
   - **Memory Leaks**: Detect memory leaks and excessive allocations

2. **Frontend Optimizations**:
   - **Code Splitting**: Implement dynamic imports and lazy loading
   - **Tree Shaking**: Remove unused code from bundles
   - **Image Optimization**: Add responsive images and modern formats
   - **Caching Strategies**: Implement service workers and cache headers
   - **Critical CSS**: Inline critical styles and defer non-critical CSS
   - **JavaScript Minification**: Optimize and compress JS assets

3. **Backend Optimizations**:
   - **Database Indexing**: Add missing indexes for query optimization
   - **Query Optimization**: Refactor inefficient database queries
   - **Caching Layers**: Implement Redis/Memcached where beneficial
   - **Connection Pooling**: Optimize database connection management
   - **API Rate Limiting**: Prevent resource exhaustion
   - **Background Jobs**: Move heavy tasks to queues

4. **Infrastructure Optimizations**:
   - **CDN Configuration**: Optimize content delivery
   - **Compression**: Enable gzip/brotli compression
   - **HTTP/2 Features**: Leverage server push and multiplexing
   - **Container Optimization**: Optimize Docker images and resource limits
   - **Load Balancing**: Improve traffic distribution

### Optimization Categories:

**JavaScript/TypeScript:**
- Replace inefficient algorithms with optimal ones
- Implement memoization for expensive calculations
- Add virtualization for long lists
- Optimize React re-renders with useMemo/useCallback
- Bundle optimization with Webpack/Vite

**Python:**
- Profile with cProfile and optimize hotspots
- Replace list comprehensions with generators where appropriate
- Implement async/await for I/O operations
- Add database query optimization with EXPLAIN ANALYZE
- Use connection pooling for database access

**Database:**
- Add composite indexes for multi-column queries
- Optimize JOIN operations and query plans
- Implement database partitioning for large tables
- Add query result caching
- Optimize bulk operations

**General:**
- Memory pool allocation for frequent allocations
- Implement lazy loading for heavy resources
- Add compression for data storage/transmission
- Optimize regular expressions
- Reduce API payload sizes

### Performance Report Generated:
```
performance-report.md
├── Executive Summary
├── Performance Metrics (Before/After)
├── Critical Bottlenecks Fixed
├── Optimization Recommendations
├── Bundle Size Analysis
├── Database Query Performance
├── Memory Usage Analysis
└── Load Testing Results
```

### Tools Integrated:
- **Lighthouse** (Web performance)
- **webpack-bundle-analyzer** (Bundle analysis)
- **clinic.js** (Node.js profiling)
- **py-spy** (Python profiling)
- **EXPLAIN ANALYZE** (Database queries)
- **Artillery/k6** (Load testing)
- **Chrome DevTools** (Runtime profiling)

### Example Optimizations:

**Before:**
```javascript
// Inefficient array processing
const processItems = (items) => {
  return items.map(item => {
    // Expensive operation in every iteration
    const processed = heavyComputation(item);
    return processed.result;
  });
};
```

**After:**
```javascript
// Optimized with memoization
const memoizedComputation = useMemo(() => new Map(), []);
const processItems = useCallback((items) => {
  return items.map(item => {
    if (!memoizedComputation.has(item.id)) {
      memoizedComputation.set(item.id, heavyComputation(item));
    }
    return memoizedComputation.get(item.id).result;
  });
}, [memoizedComputation]);
```

**Database Query Optimization:**
```sql
-- Before: Missing index, full table scan
SELECT * FROM orders WHERE customer_id = 123 AND status = 'pending';

-- After: Added composite index
CREATE INDEX idx_orders_customer_status ON orders(customer_id, status);
```

### Performance Metrics Tracked:
- **Load Times**: First Contentful Paint, Largest Contentful Paint
- **Runtime Performance**: CPU usage, memory consumption
- **Bundle Sizes**: JavaScript, CSS, and asset sizes  
- **Database Performance**: Query execution times, hit ratios
- **API Response Times**: Endpoint latency and throughput
- **Memory Leaks**: Heap usage over time

### Options:
- `--profile`: Run performance profiling before optimization
- `--frontend-only`: Focus on client-side optimizations
- `--backend-only`: Focus on server-side optimizations
- `--database-only`: Only optimize database queries and indexes
- `--bundle-analysis`: Generate detailed bundle size report
- `--load-test`: Run load testing after optimizations