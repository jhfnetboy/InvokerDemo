// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.30;

/**
 * The Execution struct represents a single execution.
 */
struct Execution {
    address target;
    uint256 value;
    bytes data;
}

/**
 * EIP-3074 Invoker Demo
 *  Since `EIP-3074` has not been activated yet, the current source code cannot be compiled.
 *  However, the current example can be used to demonstrate the operation of `EIP-3074` once it is activated.
 */
contract Invoker {
    /**
     * Invoker entry point function.
     * @param authority The address of the EOA user who wants to execute the transactions via EIP-3074.
     * @param executions The array of executions to be executed.
     * @param authSignature The signature of `keccak256(MAGIC || chainId || nonce || invokerAddress || commit)` signed by the authority.
     */
    function entrypoint(address authority, Execution[] calldata executions, bytes calldata authSignature) external {
        /* 
            authSignature structure:
                authSignature[offset    : offset+1 ] - yParity
                authSignature[offset+1  : offset+33] - r
                authSignature[offset+33 : offset+65] - s
         */

        require(authSignature.length >= 65, "Invalid authSignature length");

        // calculate the commit hash.
        bytes32 commit = keccak256(abi.encodePacked(executions));
        assembly ("memory-safe") {
            function allocate(length) -> pos {
                pos := mload(0x40)
                mstore(0x40, add(pos, length))
            }
            // allocate memory for the signature || commit hash
            let ptr := allocate(97)
            // copy `authSignature` to ptr[0:65]
            let authSignatureOffset := authSignature.offset
            calldatacopy(ptr, authSignatureOffset, 65)
            // write `commit` to ptr[65:97]
            mstore(add(ptr, 65), commit)
            /*
                Call `AUTH(0xf6)`
                https://eips.ethereum.org/EIPS/eip-3074#auth-0xf6
             */
            let ret := auth(authority, ptr, 97)
            // revert if AUTH failed
            if iszero(ret) { revert(0, 0) }
        }

        for (uint256 i = 0; i < executions.length; i++) {
            Execution calldata execution = executions[i];
            address target = execution.target;
            uint256 value = execution.value;
            bytes calldata data = execution.data;

            assembly ("memory-safe") {
                function allocate(length) -> pos {
                    pos := mload(0x40)
                    mstore(0x40, add(pos, length))
                }

                let calldataPtr := allocate(data.length)
                calldatacopy(calldataPtr, data.offset, data.length)
                /*
                    Call `AUTHCALL(0xf7)`
                    https://eips.ethereum.org/EIPS/eip-3074#authcall-0xf7
                    AUTHCALL does not reset authorized, but leaves it unchanged.
                    Caller is `authority` now.
                */
                let result := authcall(gas(), target, value, calldataPtr, data.length, 0, 0)

                // note: return data is ignored
                if iszero(result) {
                    let returndataPtr := allocate(returndatasize())
                    returndatacopy(returndataPtr, 0, returndatasize())
                    revert(returndataPtr, returndatasize())
                }
            }
        }
    }
}
