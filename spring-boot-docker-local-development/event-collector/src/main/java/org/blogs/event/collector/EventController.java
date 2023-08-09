package org.blogs.event.collector;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/v1/events")
public class EventController {

    Logger log = LoggerFactory.getLogger(EventController.class);

    @PostMapping(consumes = "application/json")
    @ResponseStatus(code = HttpStatus.ACCEPTED)
    public void ingestEvent(@RequestBody Map<String,Object> requestObjectEvent) {
        log.info("Event Received {}", requestObjectEvent);
    }
}
