---
allowed-tools: Task
description: Plan complex tasks and split them across parallel sub-agents (max 6) for faster execution, then merge the results.
---

## Garden Command - Parallel Task Planning & Execution

This command takes a user request, creates a comprehensive plan, splits the work across multiple parallel sub-agents (maximum 6 concurrent Task tool calls), and coordinates the merging of their results.

### Process:
1. **Planning Phase**: Analyze the user's request and break it down into logical, independent tasks
2. **Agent Assignment**: Split tasks across up to 6 parallel sub-agents using concurrent Task tool calls:
   - general-purpose agents for complex multi-step tasks
   - statusline-setup agents for Claude Code configuration
   - output-style-setup agents for styling tasks
3. **Parallel Execution**: Launch multiple Task tool calls concurrently in a single response
4. **Coordination**: Monitor progress and handle inter-task dependencies
5. **Merging**: Integrate results from all sub-agents and ensure consistency
6. **Verification**: Run final checks (tests, lint, build) if applicable

### Task Distribution Strategy:
- Identify independent tasks that can run in parallel
- Group related subtasks under single agents when beneficial
- Ensure no more than 6 agents are used simultaneously
- Balance workload across agents based on complexity

### Example Usage:
```
/garden "Add a dark mode toggle, update all components to support theming, add user preferences storage, write tests, and update documentation"
```

This would split into parallel tasks like:
1. Agent 1: Dark mode toggle component
2. Agent 2: Theme context/state management  
3. Agent 3: Update existing components for theming
4. Agent 4: User preferences storage system
5. Agent 5: Write comprehensive tests
6. Agent 6: Update documentation

The garden command will coordinate these agents and merge their work into a cohesive implementation.