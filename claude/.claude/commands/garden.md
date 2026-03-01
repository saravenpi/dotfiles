---
allowed-tools: Task, Glob, Read, Grep, Bash, TodoWrite
description: Orchestrate multiple parallel specialist agents to optimize and distribute complex coding tasks efficiently.
---

## Garden - Parallel Agent Orchestration

Intelligently breaks down complex coding tasks into specialized subtasks and executes them in parallel using domain-specific agents for maximum efficiency and quality.

### Core Philosophy:

The Garden command treats your codebase like a garden - different specialists (agents) work on different areas simultaneously, each focused on their expertise, resulting in harmonious and efficient growth.

### Process:

1. **Task Analysis & Decomposition**:
   - Analyze the user's prompt and identify discrete, parallelizable subtasks
   - Determine dependencies between tasks (what must run sequentially vs parallel)
   - Identify the optimal specialist agent type for each subtask
   - Create a comprehensive task breakdown using TodoWrite

2. **Agent Selection Strategy**:
   - **Explore agents**: For codebase exploration, pattern finding, architecture understanding
   - **General-purpose agents**: For complex multi-step implementations, refactoring, feature development
   - Choose thoroughness level based on task complexity:
     - `quick`: Simple lookups, single file operations
     - `medium`: Multi-file exploration, moderate complexity
     - `very thorough`: Comprehensive analysis, complex integrations

3. **Parallel Execution**:
   - Launch ALL independent agents in a SINGLE message with multiple Task tool calls
   - Never wait between independent tasks - maximize parallelism
   - Only execute sequentially when tasks have hard dependencies
   - Track all launched agents and their purposes

4. **Result Integration**:
   - Collect outputs from all parallel agents
   - Synthesize results into coherent implementation
   - Resolve any conflicts or overlapping changes
   - Execute dependent tasks based on agent findings

### Task Categories & Agent Mapping:

**Exploration Tasks → Explore Agent (very thorough)**:
- Understanding codebase architecture
- Finding all implementations of a pattern
- Identifying integration points
- Mapping data flow across modules
- Discovering API endpoints and their usage

**Implementation Tasks → General-purpose Agent**:
- Building new features with multiple components
- Refactoring across multiple files
- Adding comprehensive test coverage
- Implementing complex integrations
- Setting up new infrastructure

**Isolated Tasks → Can Run in Parallel**:
- Independent feature modules
- Separate test suites
- Different service implementations
- Distinct UI components
- Non-overlapping refactors

### Execution Rules:

**CRITICAL - Maximize Parallelism**:
```
✅ CORRECT - Single message, multiple agents:
*Sends one message with 4 Task tool calls simultaneously*

❌ WRONG - Sequential messages:
*Sends message with 1 Task call*
*Waits for response*
*Sends another message with 1 Task call*
*Waits for response*
```

**Dependency Management**:
- Independent tasks: Launch in parallel immediately
- Dependent tasks: Wait for prerequisite agent results
- Hybrid: Launch independent subset first, then dependent tasks

**Example Parallelization**:
```
Task: "Add authentication system with user management and audit logging"

Parallel Phase 1 (4 agents simultaneously):
├─ Agent 1: Explore existing auth patterns (Explore, very thorough)
├─ Agent 2: Explore user data models (Explore, medium)
├─ Agent 3: Explore logging infrastructure (Explore, medium)
└─ Agent 4: Research security best practices in codebase (Explore, quick)

Sequential Phase 2 (after gathering results):
├─ Agent 5: Implement auth core (general-purpose)
└─ Agent 6: Implement audit logging (general-purpose)

Parallel Phase 3 (both independent):
├─ Agent 7: Add user management UI (general-purpose)
└─ Agent 8: Write comprehensive tests (general-purpose)
```

### Task Breakdown Template:

For each coding task, decompose into:

1. **Discovery Phase** (parallel):
   - What patterns/code already exist?
   - What dependencies/integrations are needed?
   - What's the current architecture?
   - What are the constraints?

2. **Planning Phase** (after discovery):
   - Design the solution architecture
   - Identify implementation order
   - Plan testing strategy

3. **Implementation Phase** (maximize parallelism):
   - Core functionality
   - UI components (if independent)
   - API endpoints (if independent)
   - Database migrations (if independent)

4. **Integration Phase** (sequential if needed):
   - Connect independent pieces
   - End-to-end testing
   - Documentation

### Quality Assurance:

Each agent should be instructed to:
- Follow existing code patterns and conventions
- Write clean, maintainable code
- Include error handling
- Consider edge cases
- Add appropriate logging
- Follow the project's style guide

### Output Format:

After all agents complete:
1. Summarize what each agent accomplished
2. Show how the pieces fit together
3. Highlight any conflicts resolved
4. Provide next steps if any
5. Report overall impact (files changed, features added, etc.)

### Usage Examples:

```bash
# Simple feature with exploration
/garden add user profile editing with avatar upload

# Complex multi-system feature
/garden implement real-time notifications with WebSocket support, push notifications, and email fallback

# Large refactoring
/garden refactor the API layer to use a repository pattern and add comprehensive error handling

# Full-stack feature
/garden create an admin dashboard with user management, analytics, and audit logs
```

### Optimization Strategies:

**Maximize Agent Count**:
- Don't hesitate to launch 3-6 agents in parallel for complex tasks
- More specialized agents = better quality and faster execution
- Each agent can focus deeply on their specific domain

**Minimize Wait Time**:
- Identify what can be done without dependencies
- Launch all independent work immediately
- Only wait when absolutely necessary

**Smart Agent Selection**:
- Use Explore agents for understanding (they're optimized for search/analysis)
- Use general-purpose agents for building (they're optimized for implementation)
- Match thoroughness to complexity (don't over-engineer simple tasks)

### Error Handling:

If an agent fails or returns unexpected results:
1. Analyze the failure reason
2. Adjust the approach if needed
3. Relaunch with refined instructions
4. Don't let one failure block other parallel work

### Remember:

- **Parallel by default**: Only go sequential when dependencies require it
- **Specialist agents**: Match agent type to task nature
- **One message rule**: Launch all independent agents in a single message
- **Track everything**: Use TodoWrite to maintain visibility
- **Synthesize results**: Agents work independently, you integrate their outputs

The goal is to work like a well-coordinated garden team - everyone knows their job, works simultaneously on their area, and the result is a beautiful, cohesive garden.
