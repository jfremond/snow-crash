# Snow Crash - by [jodufour](https://github.com/JonathanDUFOUR) and [jfremond](https://github.com/jfremond/)
> A 42 school project that serves as a modest introduction to cyber
> security, through a series of levels focused on privilege
> escalation.

## 📖 Overview
This project is a hands-on introduction to the wide world of cyber
security. Working inside a dedicated VM, we progress through a series of
levels (`level00` to `level14`), each running as its own user. At every
level, the goal is to find a weakness — a misconfiguration, a vulnerable
binary, a bad permission, a logic flaw — that lets us escalate from the
current user to the next `flagXX` account and retrieve its token using
`getflag`.

## 🎯 Objectives
-   Discover common **privilege escalation** techniques on a Linux system
-   Learn to spot and exploit **weaknesses** in binaries and scripts:
misconfigured permissions, insecure SUID binaries, predictable
credentials, exposed secrets, etc.
-   Practice **command injection** when direct access to a `flagXX`
account isn't possible
-   Get comfortable navigating and investigating an unfamiliar system
(processes, file permissions, cron jobs, environment variables, etc.)
-   Develop autonomous, logical problem-solving: work through dead ends
without relying on given solutions
-   Document and justify every step taken to solve each level, without
including any binary files in the repository

## 📚 Lexicon
-   **Privilege escalation**: The act of exploiting a bug, misconfiguration
or design flaw to gain elevated access to resources that are normally
restricted from the current user.
-   **SUID (Set User ID)**: A special file permission that lets a binary
run with the privileges of its owner rather than the user executing
it, which can be exploited if the binary is unsafe.
-   **Command injection**: A vulnerability where an attacker can execute
arbitrary system commands by manipulating input that a program passes
unsanitized to a shell.
