# Corner-case checklist

Careful Q&A still misses defects that live in edge conditions. Use this checklist to find them without inflating the question count.

**How to use it:**
1. List the surfaces each component touches (below).
2. For each applicable condition, decide: does the user's world determine the answer?
   - **Yes:** ask it, batched with the other Requirements questions.
   - **No, there's a sensible default:** write it as an assumption the user can correct.
3. Each corner ends as exactly one of:
   - a requirement or Given/When/Then AC
   - an assumption with a reason
   - an explicit out-of-scope item

   A corner that's left silent counts as a review finding.

| Surface | Conditions to consider |
|---|---|
| **Text input** | empty or whitespace; very long; Unicode, emoji, RTL; leading or trailing spaces; case sensitivity; HTML or script content |
| **Numbers and money** | zero, negative, max values; rounding and precision; currency and conversion; units |
| **Time** | time zones and DST; past or future dates; date boundaries (month end, leap day); clock skew; expiry |
| **Identity and access** | anonymous user; deleted or suspended user; role changes mid-session; the same person with two accounts; acting on someone else's resource |
| **Collections** | none, one, many; duplicates; ordering; pagination; very large result sets |
| **Files and paths** | missing file; wrong type; huge file; a delimiter or quote inside a value; two spellings of one path; encoding |
| **Parsed formats** (CSV, JSON, XML) | missing fields; extra fields; malformed rows; schema version skew |
| **Network and integrations** | timeout; partial failure; retry duplicates; rate limits; the dependency is down; slow responses |
| **Storage and state** | concurrent edits; lost update; partial write; migration of existing data; soft vs hard delete |
| **Concurrency and workflow** | two approvers acting at once; out-of-order events; re-submission; cancellation mid-flow |
| **UI** | double-click submit; back button; refresh mid-flow; slow network; accessibility (keyboard, screen reader) |
| **Config and environment** | a missing env var; per-environment differences; feature flag on or off |
| **Security and privacy** | PII in logs; enumeration (guessable IDs); injection; audit requirements; data retention |
| **AI or generated output** | empty or nonsense output; hallucinated values; latency; cost limits; prompt injection via user content |
