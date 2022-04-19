//SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.13;

import "./TokenERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract Bridge {

    using ECDSA for *;

    TokenERC20 public token;
    address backendSigner;
    uint256 nonce;

    mapping(uint256 => bool) private _nonces;

    constructor(address _token, address _backendSigner) {
        token = TokenERC20(_token);
        backendSigner = _backendSigner;
    }

    // Functions

    function swap(address _to, uint256 _amount, bytes calldata _signature) external {
        require(_amount > 0, "Amount must be greater than 0");
        bytes32 message = ECDSA.toEthSignedMessageHash(keccak256(abi.encodePacked(_to, _amount)));
        require(ECDSA.recover(message, _signature) == msg.sender, "Sender must sign message with private key");
        token.burn(msg.sender, _amount);
        emit SwapInitialized(msg.sender, _to, _amount, nonce, _signature);
        nonce ++;

    }

    function redeem(address _from, address _to, uint256 _amount, uint256 _nonce, bytes calldata _senderSignature, bytes calldata _backendSignature) external {
        require(_nonces[_nonce] == false, "Transfer already processed");
        bytes32 message = ECDSA.toEthSignedMessageHash(keccak256(abi.encodePacked(_from, _to, _amount, _nonce, _senderSignature)));
        require(ECDSA.recover(message, _backendSignature) == backendSigner, "Wrong signature from backend");
        _nonces[_nonce] = true;
        token.mint(_to, _amount);

        emit Redeemed(_from, _to, _amount);
    }

    // Events

    event SwapInitialized(
        address _from,
        address _to,
        uint256 amount,
        uint256 _nonce,
        bytes _signature
    );

    event Redeemed(address _from, address _to, uint256 amount);
}
