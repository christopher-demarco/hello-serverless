import hello

def test_main():
    resp = hello.main(None, None)
    assert resp['statusCode'] == 200
    assert resp['body'] == '"Hello, world!"'
