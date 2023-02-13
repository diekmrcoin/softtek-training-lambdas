const { RateLimiterMemory } = require("rate-limiter-flexible");

class RateLimiter {
  constructor() {
    this.options = {
      points: 2, // points to consume in the time frame
      duration: 30, // seconds duration of the time frame
      blockDuration: 60, // seconds the user will be blocked if they exceed the points
    };
    this.limiter = new RateLimiterMemory(this.options);
  }
  async consume(id) {
    return new Promise((resolve) => {
      this.limiter
        .consume(id, 1)
        .then((rateLimiterRes) => {
          resolve(true);
        })
        .catch((rateLimiterRes) => {
          resolve(false);
        });
    });
  }
}

module.exports = { RateLimiter };
