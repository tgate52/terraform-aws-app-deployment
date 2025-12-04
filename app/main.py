from flask import Flask

app = Flask(__name__)

@app.route("/")
def index():
    return "Hello from your Terraform + AWS + EC2 + ALB app!"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)
