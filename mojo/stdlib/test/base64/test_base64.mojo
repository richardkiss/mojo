# ===----------------------------------------------------------------------=== #
# Copyright (c) 2025, Modular Inc. All rights reserved.
#
# Licensed under the Apache License v2.0 with LLVM Exceptions:
# https://llvm.org/LICENSE.txt
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ===----------------------------------------------------------------------=== #
# RUN: %mojo %s

from base64 import b16decode, b16encode, b64decode, b64encode

from testing import assert_equal, assert_raises


def bytes_to_str(b: Span[mut=False, UInt8]) -> String:
    # Helper to convert Span[UInt8] to String for test comparison
    var s = String(capacity=len(b))
    for byte in b:
        s.append_byte(byte)
    return s^


def test_b64encode():
    assert_equal(b64encode("a"), "YQ==")

    assert_equal(b64encode("fo"), "Zm8=")

    assert_equal(b64encode("Hello Mojo!!!"), "SGVsbG8gTW9qbyEhIQ==")

    assert_equal(b64encode("Hello 🔥!!!"), "SGVsbG8g8J+UpSEhIQ==")

    assert_equal(
        b64encode("the quick brown fox jumps over the lazy dog"),
        "dGhlIHF1aWNrIGJyb3duIGZveCBqdW1wcyBvdmVyIHRoZSBsYXp5IGRvZw==",
    )

    assert_equal(b64encode("ABCDEFabcdef"), "QUJDREVGYWJjZGVm")
    assert_equal(b64encode("\x00\n\x14\x1e(2<FPZdn"), "AAoUHigyPEZQWmRu")
    # 43 random bytes
    assert_equal(
        b64encode(
            "\xc5f\xff}\xc3\x1a\xc7\xfe]+M\x02O\xe9\xd645\xb8}\xbcN\xcc\x13:W\x0f?\n}\n\xcc\xe1\xd91\x97\x8bB\xd1\x8ej\xff\x08:"
        ),
        "xWb/fcMax/5dK00CT+nWNDW4fbxOzBM6Vw8/Cn0KzOHZMZeLQtGOav8IOg==",
    )


def test_b64decode():
    assert_equal(bytes_to_str(b64decode("YQ==")), "a")
    assert_equal(bytes_to_str(b64decode("Zm8=")), "fo")
    assert_equal(
        bytes_to_str(b64decode("SGVsbG8gTW9qbyEhIQ==")), "Hello Mojo!!!"
    )
    assert_equal(bytes_to_str(b64decode("SGVsbG8g8J+UpSEhIQ==")), "Hello 🔥!!!")
    assert_equal(
        bytes_to_str(
            b64decode(
                "dGhlIHF1aWNrIGJyb3duIGZveCBqdW1wcyBvdmVyIHRoZSBsYXp5IGRvZw=="
            )
        ),
        "the quick brown fox jumps over the lazy dog",
    )
    assert_equal(bytes_to_str(b64decode("QUJDREVGYWJjZGVm")), "ABCDEFabcdef")

    with assert_raises(
        contains="ValueError: Input length '21' must be divisible by 4"
    ):
        _ = b64decode[validate=True]("invalid base64 string")

    with assert_raises(
        contains="ValueError: Unexpected character ' ' encountered"
    ):
        _ = b64decode[validate=True]("invalid base64 string!!!")


def test_b16encode():
    assert_equal(b16encode("a".as_bytes()), "61")
    assert_equal(b16encode("fo".as_bytes()), "666F")
    assert_equal(
        b16encode("Hello Mojo!!!".as_bytes()), "48656C6C6F204D6F6A6F212121"
    )
    assert_equal(
        b16encode("Hello 🔥!!!".as_bytes()), "48656C6C6F20F09F94A5212121"
    )
    assert_equal(
        b16encode("the quick brown fox jumps over the lazy dog".as_bytes()),
        "74686520717569636B2062726F776E20666F78206A756D7073206F76657220746865206C617A7920646F67",
    )
    assert_equal(
        b16encode("ABCDEFabcdef".as_bytes()), "414243444546616263646566"
    )


def test_b16decode():
    assert_equal(bytes_to_str(b16decode("61")), "a")
    assert_equal(bytes_to_str(b16decode("666F")), "fo")
    assert_equal(
        bytes_to_str(b16decode("48656C6C6F204D6F6A6F212121")), "Hello Mojo!!!"
    )
    assert_equal(
        bytes_to_str(b16decode("48656C6C6F20F09F94A5212121")), "Hello 🔥!!!"
    )
    assert_equal(
        b16encode("the quick brown fox jumps over the lazy dog".as_bytes()),
        "74686520717569636B2062726F776E20666F78206A756D7073206F76657220746865206C617A7920646F67",
    )
    assert_equal(
        bytes_to_str(b16decode("414243444546616263646566")), "ABCDEFabcdef"
    )


def main():
    test_b64encode()
    test_b64decode()
    test_b16encode()
    test_b16decode()
