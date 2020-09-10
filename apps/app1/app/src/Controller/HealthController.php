<?php

declare(strict_types=1);

namespace App\Controller;

use Symfony\Component\HttpFoundation\Response;

final class HealthController
{
    public function __invoke(): Response
    {
        return new Response('I am a PHP service for Rafael\'s Zoover DevOps application 👍', 200);
    }
}
