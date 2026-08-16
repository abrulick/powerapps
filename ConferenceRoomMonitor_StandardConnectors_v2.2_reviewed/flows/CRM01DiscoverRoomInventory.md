# CRM01DiscoverRoomInventory

Trigger: Power Apps (V2)

Outputs:
- roomsJson (Text)
- roomCount (Number)
- correlationId (Text)
- errorText (Text)

## Steps

1. Initialize correlationId = `guid()`.
2. Get room lists (V2).
3. For each room list:
   - Get rooms in room list (V2)
   - append roomListName, roomListAddress, roomName, lowercase roomEmail.
4. If the tenant has no room lists, optionally fall back to Get rooms (V2) with the documented 100-room limitation.
5. Deduplicate by lowercase RoomEmail.
6. Respond to Power Apps.

No caller-supplied inventory is accepted.
